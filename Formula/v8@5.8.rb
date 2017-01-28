# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8AT58 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
  version "5.8.60"

  keg_only "Provided V8 formula is co-installable and it is not installed in the library path."

  # not building on Yosemite
  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  # depot_tools/GN require Python 2.7+
  depends_on :python => :build

  needs :cxx11


  def install
    (buildpath/"depot_tools").install buildpath.children - [buildpath/".brew_home"]
    # This env variable used by gclient to prevent depot_tools to update depot_tools on every call
    # see https://www.chromium.org/developers/how-tos/depottools#TOC-Disabling-auto-update
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

    # For formula development purposes we may want to avoid fetching v8 on every call as it is time-consuming,
    # so we backup/restore fetched v8 sources to directory specified in DEV_CACHE_DEPS env variable (if any).
    # To refresh cache you have to delete cached v8 folder (the one you pass as DEV_CACHE_DEPS), and it will be
    # refreshed on a next run
    cache_location = ENV["DEV_CACHE_DEPS"]
    # For formula development purposes we may want to avoid syncing v8 sources and deps (to avoid full rebuild)
    # so when DEV_NO_SYNC env variable passed alongside DEV_CACHE_DEPS, no v8 sync will be done.
    no_sync = ENV["DEV_NO_SYNC"]

    # Note: at this time we don't run tests
    # For formula development purposes we may want to avoid running full v8 test suite as it's time consuming.
    # run_tests = ENV["DEV_RUN_TESTS"]
    # Always run tests when formula is being built as a bottle (uncomment below to make that happened)
    # run_tests = build.bottle? || ENV["DEV_RUN_TESTS"]

    # We consider x.y-lkgr as our version branch HEAD because v8 doesn't have version major.minor branches and
    # real HEAD on v8 will point to master, so lkgr is the best simple ans reliable way to get latest version.
    # Normally, it is just a few releases behind real latest version and as v8 releases quite often, it's ok.
    v8_version = build.head? ? "5.8-lgkr" : version

    if cache_location and File.directory?(cache_location)
      cp_r(cache_location, "v8")
    else
      system "gclient", "sync", "-vvv", "-j #{Hardware::CPU.cores}", "-r", v8_version unless no_sync

      if cache_location and !File.exist?(cache_location)
        cp_r("v8", cache_location)
      end
    end

    cd "v8" do
      arch = MacOS.prefer_64_bit? ? "x64" : "x86"
      output_name = "#{arch}.release"
      output_path = "out.gn/#{output_name}"

      # Configure build
      gn_args = {
        is_debug: false,
        is_component_build: true,
        v8_use_external_startup_data: false,
      }

      # Patch d8 (1/2) to make it relocatable: allows icudtl.dat being loaded from keg shared directory
      inreplace "src/d8.cc",
                "v8::V8::InitializeICUDefaultLocation(argv[0],",
                "v8::V8::InitializeICUDefaultLocation(\"#{share}/\","

      gn_command = "gn gen #{output_path} --args=\"#{gn_args.map { |k, v| "#{k}=#{v}" }.join(' ')}\""
      system gn_command

      system "ninja", "-j #{Hardware::CPU.cores}", "-v", "-C", output_path

      # As we patched d8, we now need to have that new ICU data location to be created before we run tests,
      # at this time we just ignore running tests rather then playing with running that tests
      #system "tools/run-tests.py", "--outdir", output_path if run_tests

      # Patch d8 (2/2) to make it relocatable: specify valid @rpath
      File.chmod(0777, "#{output_path}/d8")
      system "install_name_tool", "-add_rpath", lib, "#{output_path}/d8"
      File.chmod(0555, "#{output_path}/d8")

      include.install Dir["include/*"]

      cd output_path do
        lib.install Dir["lib*.dylib"]
        share.install "icudtl.dat"
        bin.install "d8" => "v8"
      end
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
    assert_equal "12/20/2012", pipe_output("#{bin}/v8 -e 'var date = new Date(Date.UTC(2012, 11, 20, 3, 0, 0)); print(new Intl.DateTimeFormat(\"en-US\").format(date));'").chomp
  end
end
