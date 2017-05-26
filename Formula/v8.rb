# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
  version "5.6.326"
  head "https://chromium.googlesource.com/chromium/tools/depot_tools.git"

  bottle do
    cellar :any
    sha256 "8106efc14371982af11a66d8db533dc0589bc240950e0e445467cf6ce8871393" => :sierra
    sha256 "487f2ca72096ee27d13533a6dad2d472a92ba40ef518a45226f19e94d4a79242" => :el_capitan
    sha256 "dc9af3e08eda8a4acd1ff3c6b47a4c5170a92dbab7d2d79958a14d8aa42eefac" => :yosemite
    sha256 "7bcd1bbd66c11305eeea0c36ca472de8a639f511abe0909c8815b1208dbce7b6" => :mavericks
  end

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  # depot_tools/GN require Python 2.7+
  depends_on :python => :build

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

    cache_location = ENV["CACHE_DEPS"]
    no_sync = ENV["NO_SYNC"]

    if cache_location && File.directory?(cache_location)
      cp_r cache_location, "v8"
    end

    system "gclient", "sync", "-vvv", "-j #{Hardware::CPU.cores}", "-r", version unless no_sync

    if !no_sync
      rm_rf cache_location
      cp_r "v8", cache_location
    end

    cd "v8" do
      arch = MacOS.prefer_64_bit? ? "x64" : "x86"
      output_name = "#{arch}.release"
      output_path = "out.gn/#{output_name}"

      # Configure build
      gn_args = {
        :is_debug => false,
        :is_component_build => true,
        :v8_use_external_startup_data => false,
      }

      gn = "gn gen #{output_path} --args=\"#{gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")}\""
      system gn
      system "ninja", "-j #{Hardware::CPU.cores}", "-v", "-C", output_path, "d8"

      include.install Dir["include/*"]

      cd output_path do
        lib.install Dir["lib*.dylib"]
        bin.install "d8" => "v8"
      end
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
