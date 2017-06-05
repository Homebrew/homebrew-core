# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://chromium.googlesource.com/v8/v8.git", :tag => "5.4.500.41"

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

  resource "depot_tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
      :revision => "e0b205e884ca787fb96c29799ac0260e6a07d84a"
  end

  def install
    ENV["DEPOT_TOOLS_UPDATE"] = "0"

    (buildpath/"depot_tools").install resource("depot_tools")
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
    system "gclient", "sync", "--reset", "-r", version

    cd "v8" do
      run_tests = build.bottle? || build.with?("test")

      # Generate static libraries
      system "ninja", "-C", "out/Release"
      system "out/Release/unittests" if run_tests

      # Configure build to generate binaries/dylibs
      arch = MacOS.prefer_64_bit? ? "x64" : "x86"
      output_name = "#{arch}.release"
      output_path = "out.gn/#{output_name}"
      system "tools/dev/v8gen.py", output_name, "--",
        "is_component_build=true", "v8_use_external_startup_data=false"

      # Patch source to link dylibs correctly
      block_pattern = %r/
        (?<header>
          \ntemplate\("v8_component"\)
          \s* { \p{blank}* \n
          (?: \p{blank}*(?:(?!component)\w+|[^\s\w]+)[^\n]*\n)*
          \s* component
          \s* \([^)]+\)
          \s* { \p{blank}* \n+
        )
        (?<indentation>\p{blank}*)
        (?<content>
          \s* (?<code>(?:[^{\#]+|\#[^\n]*\n|{\g<code>))+
          \s* }
          \s* }
        )
      /mix

      file_contents.gsub!(block_pattern) {
        block = Regexp.last_match
        header = block["header"]
        indent = block["indentation"]
        content = block["content"]

        ldflags = <<-EOS.undent
          ldflags = [
            "-dynamiclib",
            "-all_load",
            "-Wl,-rpath,/usr/local/opt/v8/lib"
          ]\n
        EOS

        # Preserve indentation when injecting; GN is prickly
        # about whitespace and might trigger linting errors.
        header += ldflags.gsub /^/, indent

        # Avoid overwriting existing assignments
        if /\bldflags\s*=/.match content
          content.gsub! /ldflags\s*\K=/m, "+="
        end

        header + indent + content
      }

      # Generate shared libraries
      system "ninja", "-C", output_path
      #system "git", "checkout", "--", "gni/v8.gni"
      system "tools/run-tests.py", "--outdir", output_path if run_tests

      include.install Dir["include/*"]

      # Install static libraries
      cd "out/Release" do
        rm ["libgmock.a", "libgtest.a"]
        lib.install Dir["lib*"]
      end

      # Install shared libraries and executables
      cd output_path do
        lib.install Dir["*.dylib"]
        bin.install "d8", "mksnapshot", "v8_sample_process", "v8_shell" => "v8"
      end
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
