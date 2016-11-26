# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
    :revision => "e0b205e884ca787fb96c29799ac0260e6a07d84a"
  version "5.4.500.41"

  bottle do
    cellar :any
    sha256 "8106efc14371982af11a66d8db533dc0589bc240950e0e445467cf6ce8871393" => :sierra
    sha256 "487f2ca72096ee27d13533a6dad2d472a92ba40ef518a45226f19e94d4a79242" => :el_capitan
    sha256 "dc9af3e08eda8a4acd1ff3c6b47a4c5170a92dbab7d2d79958a14d8aa42eefac" => :yosemite
    sha256 "7bcd1bbd66c11305eeea0c36ca472de8a639f511abe0909c8815b1208dbce7b6" => :mavericks
  end

  option "with-test", "Verify each build step using the test-suite"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  # depot_tools/GN require Python 2.7+
  depends_on :python if MacOS.version <= :snow_leopard

  needs :cxx11

  def install
    (buildpath/"depot_tools").install buildpath.children - [buildpath/".brew_home"]
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.prepend_path "PATH", buildpath/"depot_tools"

    system "gclient", "root"
    system "gclient", "config", "--spec", <<-EOS.undent
      solutions = [
        {
          "url": "https://chromium.googlesource.com/v8/v8.git",
          "managed": False,
          "name": "v8",
          "deps_file": "DEPS",
          "custom_deps": {},
        },
      ]
      target_os = [ "mac" ]
      target_os_only = True
    EOS
    system "gclient", "sync", "-r", "#{version}"

    cd "v8" do
      system "git", "submodule", "foreach", "git config -f $toplevel/.git/config submodule.$name.ignore all"
      system "git", "config", "--add", "remote.origin.fetch", "+refs/tags/*:refs/tags/*"
      system "git", "config", "diff.ignoreSubmodules", "all"

      arch = MacOS.prefer_64_bit? ? "x64" : "x86"
      output_name = "#{arch}.release"
      output_path = "out.gn/#{output_name}"
      run_tests = build.bottle? || build.with?("test")

      # Configure build
      system "tools/dev/v8gen.py", output_name

      # Necessary to generate libv8.dylib; can't be added using gn/v8gen.py
      dylib_args = <<-EOS.undent
        is_component_build = true
        v8_enable_i18n_support = false
      EOS

      # Generate libv8.dylib
      inreplace "#{output_path}/args.gn", /\z/, dylib_args
      system "ninja", "-C", output_path
      inreplace "#{output_path}/args.gn", dylib_args, ""
      system "tools/run-tests.py", "--outdir", output_path if run_tests

      # Tamper with gni/v8.gni to generate lib*.a files
      inreplace "gni/v8.gni", %r|(template\("v8_source_set"\)\s*{\s*)source_set|, "\\1static_library"
      system "ninja", "-C", output_path
      system "git", "checkout", "--", "gni/v8.gni"
      system "tools/run-tests.py", "--outdir", output_path if run_tests

      include.install Dir["include/*"]

      cd output_path do
        lib.install Dir["libv8.dylib"]

        cd "obj" do
          lib.install Dir["lib*"]
        end

        bin.install "d8", "mksnapshot", "v8_sample_process", "v8_shell" => "v8"
      end
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
