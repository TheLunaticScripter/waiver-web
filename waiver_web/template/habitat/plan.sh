pkg_name=waiver_profile_example
pkg_version=0.1.0
pkg_origin=thelunaticscripter
pkg_build_deps=(chef/inspec thelunaticscripter/test_web_linux_baseline)
pkg_deps=(chef/inspec core/ruby core/hab thelunaticscripter/test_web_linux_baseline)
pkg_svc_user=root
pkg_license='Apache-2.0'


do_build() {
  cp -vr $PLAN_CONTEXT/../* $HAB_CACHE_SRC_PATH/$pkg_dirname
  rm "inspec.yml"
  rm "inspec.lock"
  cat << EOF >> "inspec.yml"
name: $pkg_name
title: InSpec Profile
maintainer: The Authors
copyright: The Authors
copyright_email: you@example.com
license: Apache-2.0
summary: An InSpec Compliance Profile
version: $pkg_version
depends:
- name: test_web_linux_baseline
  path: $(pkg_path_for thelunaticscripter/test_web_linux_baseline)/dist
EOF
inspec vendor --overwrite
}

do_install() {
  local profile_contents
  local excludes
  profile_contents=($(ls))
  excludes=(habitat results *.hart)

  for item in ${excludes[@]}; do
    profile_contents=(${profile_contents[@]/$item/})
  done

  mkdir ${pkg_prefix}/dist
  cp -r ${profile_contents[@]} ${pkg_prefix}/dist/
}
