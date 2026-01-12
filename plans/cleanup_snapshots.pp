# @summary Cleanup unreferenced aptly snapshots
#
# NOTE: This plan should be run against a server, that has aptly installed and executable.
#
# @param targets
#   Target server to run `aptly` command on
# @param filter
#   Only delete unreferenced snapshots matching this regexp pattern
# @param noop
#   Whether to really delete snapshots or just report them
#
# @return [ResultSet] Set of run_task Results
plan aptly::cleanup_snapshots(
  TargetSpec $targets,
  Boolean $noop = false,
  Optional[String[1]] $filter = undef,
) {
  $tt = $targets.get_targets
  if $tt.length > 1 {
    fail_plan('This plan cannot deal with more than one target', 'aptly::cleanup_snapshots/too-many-targets', count => $tt.length)
  }

  # Collect published snapshots
  $publish_res = run_task('aptly::publish_list', $targets)
  $published_snapshots = $publish_res.first.value['publish_list'].reduce([]) |$memo, $x| {
    if $x['SourceKind'] == 'snapshot' {
      $memo + $x.get('Sources', []).map |$s| {
        $name = $s['Name']
      }
    } else {
      $memo
    }
  }

  # Collect snapshots, matching the filter (if given)
  $snapshot_res = run_task('aptly::snapshot_list', $targets)
  $snapshots = $snapshot_res.first.value['snapshot_list'].reduce([]) |$memo, $x| {
    $name = $x['Name']
    if $filter {
      if $name =~ $filter {
        $memo + $name
      } else {
        $memo
      }
    } else { # No filter given
      $memo + $name
    }
  }

  $disposed_snapshots = $snapshots - $published_snapshots
  $result = $disposed_snapshots.map |$snapshot| {
    if $noop {
      out::verbose("Deleting snapshot ${snapshot}...")
      Result($tt[0], { snapshot_drop => true, noop => true })
    } else {
      run_task('aptly::snapshot_drop', $targets, name => $snapshot).first
    }
  }

  return ResultSet($result)
}
