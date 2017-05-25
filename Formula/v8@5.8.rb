# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8AT58 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8/archive/5.8.69.tar.gz"
  sha256 "15271aa814a8e00f8a1b493084513eb5e0b88d6a4ca662f26f0a446bfe568d99"

  keg_only "Provided V8 formula is co-installable and it is not installed in the library path."

  # not building on Yosemite
  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  # depot_tools/GN require Python 2.7+
  depends_on :python => :build

  needs :cxx11

  resource "depot_tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        :revision => "7afd16467e2c4f4375584746e698a6f0db5a42f9"
  end

  def install
    (buildpath/"depot_tools").install resource("depot_tools")
    ENV.prepend_path "PATH", buildpath/"depot_tools"

    # This env variable used by gclient to prevent depot_tools to update depot_tools on every call
    # see https://www.chromium.org/developers/how-tos/depottools#TOC-Disabling-auto-update
    ENV["DEPOT_TOOLS_UPDATE"] = "0"

    repo_cache = HOMEBREW_CACHE/"#{name}--v8--gclient/"
    repo_cache.mkpath

    # Configure build
    gn_args = {
        is_debug: false,
        is_component_build: true,
        v8_use_external_startup_data: false,
    }

    v8_version = version
    arch = MacOS.prefer_64_bit? ? "x64" : "x86"
    output_name = "#{arch}.release"
    output_path = "out.gn/#{output_name}"

    gn_command = "gn gen #{output_path} --args=\"#{gn_args.map { |k, v| "#{k}=#{v}" }.join(' ')}\""

    cd repo_cache do
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

      system "gclient", "sync", "-vvv", "-j #{Hardware::CPU.cores}", "-r", v8_version

      cd "v8" do
        system gn_command
        system "ninja", "-j #{Hardware::CPU.cores}", "-v", "-C", output_path, "d8"

        include.install Dir["include/*"]

        cd output_path do
          lib.install Dir["lib*.dylib", "icudtl.dat", "d8"]
        end
      end
    end
  end

  test do
    test_basic_script = <<-EOS.strip
      print("Hello World!");
    EOS

    test_icu_script = <<-EOS.undent.tr("\n", " ").strip
      var date = new Date(Date.UTC(2012, 11, 20, 3, 0, 0));
      print(new Intl.DateTimeFormat("en-US").format(date));
    EOS

    assert_equal "Hello World!", pipe_output("#{lib}/d8 -e '#{test_basic_script}'").chomp
    assert_match %r{12/\d{2}/2012}, pipe_output("#{lib}/d8 -e '#{test_icu_script}'").chomp
  end
end
