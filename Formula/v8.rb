class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/8.1.307.28.tar.gz"
  sha256 "09665555e7f9bcc5beedac12843b6d9467efcb2d25946b62b3ba21c2165a0a50"

  bottle do
    cellar :any
    sha256 "1bc2bd2ad9751f37b6a147dc6d50c0df75cad06e0cfcd61263052a79b0bdaff6" => :catalina
    sha256 "c44b9711d8cefdbcbc286d8f50cb81547e3f99ccd3bb7059c547200ec1e4a311" => :mojave
    sha256 "f398c1d86ed4af0d2ee558d157c01ed448734828d4df05308a60dd95444476f3" => :high_sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1100
  depends_on "ninja" => :build

  depends_on :xcode => ["10.0", :build] # required by v8

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L15
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "97cc440d84f050f99ff0161f9414bfa2ffa38f65"
  end

  # e.g.: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L60 for the revision of build for v8 7.6.303.27
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
      :revision => "2f17606c25956e800b6c4670c294a03620e78551"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
      :revision => "dbd3825b31041d782c5b504c59dcfb5ac7dda08c"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
      :revision => "bd79231eb1f9e7de2efb4ad79e530d9a7e70d9a5"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
      :revision => "306f3754a71d6d1ac644681d3544d06744914228"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
      :revision => "b41863e42637544c2941b574c7877d3e1f663e25"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
      :revision => "8f45f5cfa0009d2a70589bcda0349b8cb2b72783"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
      :revision => "b9b9a5af7cca2e683e5f2aead8418e5bf9d5a7d5"
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

    # Enter the v8 checkout
    gn_args = {
      :is_debug                     => false,
      :is_component_build           => true,
      :v8_use_external_startup_data => false,
      :v8_enable_i18n_support       => true,        # enables i18n support with icu
      :clang_base_path              => "\"/usr/\"", # uses Apples system clang instead of Google's custom one
      :clang_use_chrome_plugins     => false,       # disable the usage of Google's custom clang plugins
      :use_custom_libcxx            => false,       # uses system libc++ instead of Google's custom one
      :treat_warnings_as_errors     => false,
    }

    # use clang from homebrew llvm formula on <= Mojave, because the system clang is to old for V8
    if DevelopmentTools.clang_build_version < 1100
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib # but link against system libc++
      gn_args[:clang_base_path] = "\"#{Formula["llvm"].prefix}\""
    end

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

    (testpath/"test.cpp").write <<~'EOS'
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
    system ENV.cxx, "-std=c++11", "test.cpp",
      "-I#{libexec}/include",
      "-L#{libexec}", "-lv8", "-lv8_libplatform"
  end
end
