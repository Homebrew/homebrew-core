class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/9.0.257.29.tar.gz"
  sha256 "c39f769f791a5c374b4f4a98e12f2534a23a41cb2e278856429752b98b0fc828"
  license "BSD-3-Clause"

  livecheck do
    url "https://omahaproxy.appspot.com/all.json?os=mac&channel=stable"
    regex(/"v8_version": "v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "53088cb6df741001ff8ef989d73229009d95603ae9d61dabb2362fd782a3bf7d"
    sha256 cellar: :any, big_sur:       "9076403932bf4e554e51bff63d8ec7b122522fda1e259659c7c1db53e6699b91"
    sha256 cellar: :any, catalina:      "5e270b464f7d3d2b6ee171d9b481fac7924827632ae84673d03744244b4d37e9"
    sha256 cellar: :any, mojave:        "78dc0ec1b2ddf1fd185370ce963849bffaf28fa969d32b800b7ba2af0abf0806"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build

  depends_on xcode: ["10.0", :build] # required by v8

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/9.0.257.29/DEPS#L50
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "dfcbc6fed0a8352696f92d67ccad54048ad182b3"
  end

  # e.g.: https://github.com/v8/v8/blob/9.0.257.29/DEPS#L91 for the revision of build for v8 9.0.257.29
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "446bf3e5a00bfe4fd99d91cb76ec3b3a7b34d226"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "e05b663d1c50b4e9ecc3ff9325f5158f1d071471"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        revision: "7af6071eddf11ad91fbd5df54138f9d3c6d980d5"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "1e315c5b1a62707fac9b8f1d4e03180ee7507f98"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "11b6b3e5971d760bd2d310f77643f55a818a6d25"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "0944e71f4b2cb9a871bcbe353f95e889b64a611a"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "348acca950b1d6de784a954f4fda0952046c652c"
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
      system "python", "build/gen.py"
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

    # use clang from homebrew llvm formula, because the system clang is unreliable
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib # but link against system libc++

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install all the things
    (libexec/"include").install Dir["include/*"]
    libexec.install Dir["out.gn/lib*.dylib", "out.gn/d8", "out.gn/icudtl.dat"]
    bin.write_exec_script libexec/"d8"
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
      "-I#{libexec}/include",
      "-L#{libexec}", "-lv8", "-lv8_libplatform"
  end
end
