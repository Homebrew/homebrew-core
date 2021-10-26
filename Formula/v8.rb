class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/9.5.172.21.tar.gz"
  sha256 "ee5a4659880cf3ef05e1cfa65a280ea4b35439e59db138501a211256451ba15f"
  license "BSD-3-Clause"

  livecheck do
    url "https://omahaproxy.appspot.com/all.json?os=mac&channel=stable"
    regex(/"v8_version": "v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c80afd47ccc5b5a1fd403d7efcc7682c23c80895bc765290ff10ea2f423f3763"
    sha256 cellar: :any,                 arm64_big_sur:  "9f83d3de6f6020f1fa5c4c4c6abe8dc160d0b1ab57054e637f260e31a90f649e"
    sha256 cellar: :any,                 monterey:       "c1173caf4773569bb75efdc81c4cd6c0cf21ed22ce99f9b3933ff51db91c36b2"
    sha256 cellar: :any,                 big_sur:        "f147088ec4efc7f6265531e4e3dbf08f41ecc683bcfbf1924685ca10f2b6ccb0"
    sha256 cellar: :any,                 catalina:       "ca3e0ded2e601addfa3a1a04580427f8f0e7ed19c2269c7b3fbe3feb96881911"
    sha256 cellar: :any,                 mojave:         "463438cd767ddcaa2f9cfbd10b938d761d46bfd127fdf66bb7b961aeddde5bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a8b574107dcc2f1ca2da2740ff5a80b00471d79c72b531eefee1a165148273"
  end

  depends_on "ninja" => :build
  depends_on "python@3.9" => :build

  on_macos do
    depends_on "llvm" => :build
    depends_on xcode: ["10.0", :build] # required by v8
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/9.4.146.16/DEPS#L52
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "69ec4fca1fa69ddadae13f9e6b7507efa0675263"
  end

  # e.g.: https://github.com/v8/v8/blob/9.4.146.16/DEPS#L93 for the revision of trace event for v8 9.2.230.29
  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        revision: "715537d6007ca71837f48bcb04fc3d482aed2507"
  end

  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "17d097b0ffdc297f04afb54e9e3abff3f1203f06"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "955c7f837efad184ec63e771c42542d37545eaef"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "ece15d049f2d360721716089372e3749fb89e0f4"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "6db8da1615a13fdfab925688bc4bf2eb394a73af"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "1b882ef6372b58bfd55a3285f37ed801be9137cd"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "77c132322fe81a1f5518b326e18c99ebd3281627"
  end

  def install
    (buildpath/"build").install resource("v8/build")
    (buildpath/"third_party/jinja2").install resource("v8/third_party/jinja2")
    (buildpath/"third_party/markupsafe").install resource("v8/third_party/markupsafe")
    (buildpath/"third_party/googletest/src").install resource("v8/third_party/googletest/src")
    (buildpath/"base/trace_event/common").install resource("v8/base/trace_event/common")
    (buildpath/"third_party/icu").install resource("v8/third_party/icu")
    (buildpath/"third_party/zlib").install resource("v8/third_party/zlib")

    # Build gn from source and add it to the PATH
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    ENV.prepend_path "PATH", buildpath/"gn/out"

    # create gclient_args.gni
    (buildpath/"build/config/gclient_args.gni").write <<~EOS
      declare_args() {
        checkout_google_benchmark = false
      }
    EOS

    # setup gn args
    gn_args = {
      is_debug:                     false,
      is_component_build:           true,
      v8_use_external_startup_data: false,
      v8_enable_i18n_support:       true, # enables i18n support with icu
      clang_base_path:              "\"#{Formula["llvm"].opt_prefix}\"", # uses Homebrew clang instead of Google clang
      clang_use_chrome_plugins:     false, # disable the usage of Google's custom clang plugins
      use_custom_libcxx:            false, # uses system libc++ instead of Google's custom one
      treat_warnings_as_errors:     false, # ignore not yet supported clang argument warnings
    }

    if OS.linux?
      gn_args[:is_clang] = false # use GCC on Linux
      gn_args[:use_sysroot] = false # don't use sysroot
      gn_args[:custom_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # uses system toolchain
      gn_args[:host_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # to respect passed LDFLAGS
      ENV["AR"] = DevelopmentTools.locate("ar")
      ENV["NM"] = DevelopmentTools.locate("nm")
      gn_args[:use_rbe] = false
    end

    # use clang from homebrew llvm formula, because the system clang is unreliable
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib # but link against system libc++
    # Make sure private libraries can be found from lib
    ENV.prepend "LDFLAGS", "-Wl,-rpath,#{libexec}"

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install libraries and headers into libexec so d8 can find them, and into standard directories
    # so other packages can find them and they are linked into HOMEBREW_PREFIX
    (libexec/"include").install Dir["include/*"]
    include.install_symlink Dir[libexec/"include/*"]

    libexec.install Dir["out.gn/d8", "out.gn/icudtl.dat"]
    bin.write_exec_script libexec/"d8"

    libexec.install Dir["out.gn/#{shared_library("*")}"]
    lib.install_symlink Dir[libexec/shared_library("libv8*")]
    rm Dir[lib/"*.TOC"] if OS.linux? # Remove symlinks to .so.TOC text files
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/d8 -e 'print(\"Hello World!\");'").chomp
    t = "#{bin}/d8 -e 'print(new Intl.DateTimeFormat(\"en-US\").format(new Date(\"2012-12-20T03:00:00\")));'"
    assert_match %r{12/\d{2}/2012}, shell_output(t).chomp

    (testpath/"test.cpp").write <<~EOS
      #include <libplatform/libplatform.h>
      #include <v8.h>
      int main(){
        static std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
        v8::V8::InitializePlatform(platform.get());
        v8::V8::Initialize();
        return 0;
      }
    EOS

    # link against installed libc++
    system ENV.cxx, "-std=c++14", "test.cpp",
      "-I#{include}",
      "-L#{lib}", "-lv8", "-lv8_libplatform"
  end
end
