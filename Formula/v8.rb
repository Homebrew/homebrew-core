class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/10.0.139.15.tar.gz"
  sha256 "1090da1faa9cdcbf6a054452d21b8f6a5188601f809fcdd5c14376ecae6bfdc2"
  license "BSD-3-Clause"

  livecheck do
    url "https://omahaproxy.appspot.com/all.json?os=mac&channel=stable"
    regex(/"v8_version": "v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ce14a5eef00d846b9489c437fc0d03f3f18d85e3f35576759665b159c909603"
    sha256 cellar: :any,                 arm64_big_sur:  "f2df59cc6c10316cecb2739783878a18362a9a6b91cb74a1c52fdf8a1547fd2a"
    sha256 cellar: :any,                 monterey:       "50271ff77e4d58ed9dc1280ba49e460838aae81f5a4773f4dda426d90dd099b0"
    sha256 cellar: :any,                 big_sur:        "c5309ec7fb28e3ebc30ab157208c1c7b38ec3b8c8227ce1275a081e647f6703a"
    sha256 cellar: :any,                 catalina:       "e73c565c6f9e0dd8eb228092f62ff50df1f42e47e9bb1814162b04c09948b83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "605cc04fbbe345873a0076612e8b9d496dde355c2dd0acac7002a92e5a37f2af"
  end

  depends_on "ninja" => :build
  depends_on "python@3.10" => :build

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
  # e.g. for CIPD dependency gn: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/9.9.115.8/DEPS#43
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "0725d7827575b239594fbc8fd5192873a1d62f44"
  end

  # e.g.: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/9.9.115.8/DEPS#84
  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        revision: "d115b033c4e53666b535cbd1985ffe60badad082"
  end

  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "62a6377648eb82cff75e3a12f689400694fbbb63"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "ea55f1f52c489535f0d3b583c81529762c9cb5ea"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "b867f209e4b56b0a8c01aaaba3882ad41e438c4f"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "ee69aa00ee8536f61db6a451f3858745cf587de6"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "1b882ef6372b58bfd55a3285f37ed801be9137cd"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "9538f4194f6e5eff1bd59f2396ed9d05b1a8d801"
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
      use_lld:                      false, # upstream use LLD but this leads to build failure on ARM
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
