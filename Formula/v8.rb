class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/7.7.299.13.tar.gz"
  sha256 "1f5939fcd74464ba43e3445d3e3f82b5bbf2efe7314dde06b3fb12b65ba7d5f9"

  bottle do
    cellar :any
    sha256 "19454ea74b27155ffd92fe69122dba3aceabb0fd06dc47b9e49249e8a9a1911d" => :catalina
    sha256 "5c7172c88d66ff913f72c208bddc245dd8ac721413ca0751bd6e52867efde545" => :mojave
    sha256 "c3a0c2e343cf6176e54cedcc0a0bed4243b52e7bc9a666bdf2ddd48efe382d9a" => :high_sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1001 # 1100 with v8 7.9+
  depends_on "ninja" => :build

  depends_on :xcode => ["9.0", :build] # required by v8 (bump to 10.0 with v8 7.9+)

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L15
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "972ed755f8e6d31cae9ba15fcd08136ae1a7886f"
  end

  # e.g.: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L60 for the revision of build for v8 7.6.303.27
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
      :revision => "1e5d7d692f816af8136c738b79fe9e8dde8057f6"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
      :revision => "fd97d4326fac6da84452b2d5fe75ff0949368dab"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
      :revision => "cfe8887fa6ac3170e23a68949930e28d4705a16f"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
      :revision => "6077f444da944d96d311d358d761164261f1cdd0"
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
    if DevelopmentTools.clang_build_version < 1001 # 1100 with v8 7.9+
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
