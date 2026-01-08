# @summary Cleanup unreferenced aptly snapshots
#
# NOTE: This plan should be run against a server, that has aptly installed and executable.
#
# @param targets
#   Target server to run `aptly` command on
# @param run_as
#   Target user to run `aptly` command as
# @param pattern
#   Only delete unreferenced snapshots matching this regexp pattern
# @param noop
#   Whether to really delete snapshots or just report it
plan aptly::cleanup_snapshots(
  TargetSpec $targets,
  String[1] $run_as = 'aptly',
  Boolean $noop = false,
  Optional[String[1]] $pattern = undef,
) {
  $tt = $targets.get_targets
  if $tt.length > 1 {
    fail_plan('This plan cannot deal with more than one target', 'aptly::cleanup_snapshots/too-many-targets', count => $tt.length)
  }

  # Collect published snapshots
  $publish_res = run_task('aptly::publish_list', $targets, _run_as => $run_as)
  $published_snapshots = $publish_res.first.value['publish_list'].reduce([]) |$memo, $x| {
    if $x['SourceKind'] == 'snapshot' {
      $memo + $x.get('Sources', []).map |$s| {
        $name = $s['Name']
      }
    } else {
      $memo
    }
  }

  # Collect snapshots, matching the pattern (if given)
  $snapshot_res = run_task('aptly::snapshot_list', $targets, _run_as => $run_as)
  $snapshots = $snapshot_res.first.value['snapshot_list'].reduce([]) |$memo, $x| {
    $name = $x['Name']
    if $pattern {
      if $name =~ $pattern {
        $memo + $name
      } else {
        $memo
      }
    } else { # No pattern given
      $memo + $name
    }
  }

  $disposed_snapshots = $snapshots - $published_snapshots
  $result = $disposed_snapshots.map |$snapshot| {
    if $noop {
      out::verbose("Deleting snapshot ${snapshot}...")
    } else {
      run_task('aptly::snapshot_drop', $targets, _run_as => $run_as, name => $snapshot)
    }
  }

  return $result
}
