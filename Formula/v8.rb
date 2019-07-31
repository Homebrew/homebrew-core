class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/7.6.303.27.tar.gz"
  sha256 "e3fb2270c3ca277fa3e7ef6bd45f4d00eb7111bfd1ac440997bba2ef02ae0262"

  bottle do
    cellar :any
    sha256 "fd143a1f73fd9b0dae4fcaea6ef99c6119b376fcb0afc10ff592c6263b939388" => :mojave
    sha256 "aa6bc40ddfca624348267f863dff5df9c1382a4f67fa448abf729a73f2210a21" => :high_sierra
    sha256 "2900185e07bfdd424b1195430e72a347d3cf8e1c77ebf4b52ac75de5bb521775" => :sierra
  end

  depends_on "ninja" => :build
  depends_on "llvm" if MacOS.version < :mojave

  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L15
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "81ee1967d3fcbc829bac1c005c3da59739c88df9"
  end

  # e.g.: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L60 for the revision of build for v8 7.6.303.27
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
      :revision => "4cebfa34c79bcfbce6a3f55d1b4f7628bb70ea8a"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
      :revision => "64e5d7d43a1ff205e3787ab6150bbc1a1837332b"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
      :revision => "cfe8887fa6ac3170e23a68949930e28d4705a16f"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
      :revision => "f71fb4f9a912ec945401cc49a287a759b6131026"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
      :revision => "b41863e42637544c2941b574c7877d3e1f663e25"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
      :revision => "8f45f5cfa0009d2a70589bcda0349b8cb2b72783"
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
