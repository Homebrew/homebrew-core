class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/7.4.288.25.tar.gz"
  sha256 "8dd79e891fbe6563d75d20956475a641dcbd21bf6c35ba769204167ca8a9080c"

  bottle do
    cellar :any
    sha256 "48cb06dfcfc1afcdcb808ecdfbdd911e91fc8d68ca41855c7c62ccf740efcc46" => :mojave
    sha256 "b6e09cb2d9829fe352bfd4577360cb58418a6c3caf8d5d36a6fe04836ce5e438" => :high_sierra
    sha256 "d899ba287714639bcc34f6a42e048e64af12a72595beb757863935cf61d8c954" => :sierra
  end

  depends_on "ninja" => :build
  depends_on "python@2" => :build # GN require Python 2.7+
  depends_on "llvm" if MacOS.version < :mojave

  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g.: https://github.com/v8/v8/blob/7.4.288.25/DEPS#L19 for the revision of build for v8 7.4.288.25
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
      :revision => "80892bfe019dc854c6acdbfbb7304cca63986d4f"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
      :revision => "b41863e42637544c2941b574c7877d3e1f663e25"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
      :revision => "8f45f5cfa0009d2a70589bcda0349b8cb2b72783"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
      :revision => "efecb0bfa687cf87836494f5d62868485c00fb66"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
      :revision => "936ba8a963284a6b3737cf2f0474a7131073abee"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
      :revision => "8c67416ccb4da42d817e7081ff83a2193b1aabe7"
  end

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "64b846c96daeb3eaf08e26d8a84d8451c6cb712b"
  end

  def install
    (buildpath/"build").install resource("v8/build")
    (buildpath/"third_party/jinja2").install resource("v8/third_party/jinja2")
    (buildpath/"third_party/markupsafe").install resource("v8/third_party/markupsafe")
    (buildpath/"third_party/googletest/src").install resource("v8/third_party/googletest/src")
    (buildpath/"base/trace_event/common").install resource("v8/base/trace_event/common")
    (buildpath/"third_party/icu").install resource("v8/third_party/icu")

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
    }
    # use clang from homebrew llvm formula on <= High Sierra, because the system clang is to old for V8
    gn_args[:clang_base_path] = "\"#{Formula["llvm"].prefix}\"" if MacOS.version < :mojave

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
