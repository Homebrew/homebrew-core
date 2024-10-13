class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://v8.dev/docs"
  # Track V8 version from Chrome stable: https://chromiumdash.appspot.com/releases?platform=Mac
  url "https://github.com/v8/v8/archive/refs/tags/12.7.224.16.tar.gz"
  sha256 "00425fe7fd851f11839537256922addbfee0f5d27c6bf5ab375b9d0347d8ed94"
  license "BSD-3-Clause"

  livecheck do
    url "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Mac"
    regex(/(\d+\.\d+\.\d+\.\d+)/i)
    strategy :json do |json, regex|
      # Find the v8 commit hash for the newest Chromium release version
      v8_hash = json.max_by { |item| Version.new(item["version"]) }.dig("hashes", "v8")
      next if v8_hash.blank?

      # Check the v8 commit page for version text
      v8_page = Homebrew::Livecheck::Strategy.page_content(
        "https://chromium.googlesource.com/v8/v8.git/+/#{v8_hash}",
      )
      v8_page[:content]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c970a5657a165144470702ac586a5b17349397446a421f35e9323a0f01dcd385"
    sha256 cellar: :any,                 arm64_sonoma:   "15a1692bba6d316446d00640d6f0975a221cb519031b76e9fc8a7036c93a2550"
    sha256 cellar: :any,                 arm64_ventura:  "b40b3f0daae622cc1d258b8834c9f5f6b942652deb785c22350e9b8ce08ac7c5"
    sha256 cellar: :any,                 arm64_monterey: "d4236596413abd930b07c749b5b87c7551cc68ff744ee9878bacafe668a8b055"
    sha256 cellar: :any,                 sonoma:         "dc5ac107d6237165e8735bd3ba8b9ed4e45ccb1b5b9a9b6b97d35c7dfb4ba045"
    sha256 cellar: :any,                 ventura:        "087168f4e81ef0d7c0b343c99e5e382acc08201b499c49c55990a137397c38dd"
    sha256 cellar: :any,                 monterey:       "8340f34e94f455aa9250ba6915271606b08f14e31261c9584f098bcfa62ba532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9106a7390ca79160d728d43c22e38ced8b861c1c98e38552325efa33584f526e"
  end

  depends_on "ninja" => :build
  depends_on xcode: ["10.0", :build] # for xcodebuild, min version required by v8

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/<version>/DEPS#74
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "b3a0bff47dd81073bfe67a402971bad92e4f2423"
  end

  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "faf20f32f1d19bd492f8f16ac4a7ecfabdbb60c1"
  end

  resource "v8/third_party/fp16/src" do
    url "https://chromium.googlesource.com/external/github.com/Maratyszcza/FP16.git",
        revision: "0a92994d729ff76a58f692d3028ca1b64b145d91"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "a7f443b80b105f940225332ed3c31f2790092f47"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "98f2494518c2dbb9c488e83e507b070ea5910e95"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "2f6f2ff5e4c1d727377f5e1b9e1903d871f41e74"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "e582d7f0edb9d67499b0f5abd6ae5550e91da7f2"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "209717dd69cd62f24cbacc4758261ae2dd78cfac"
  end

  resource "v8/third_party/abseil-cpp" do
    url "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp.git",
        revision: "bfe59c2726fda7494a800f7d0ee461f0564653b3"
  end

  def install
    (buildpath/"build").install resource("v8/build")
    (buildpath/"third_party/jinja2").install resource("v8/third_party/jinja2")
    (buildpath/"third_party/markupsafe").install resource("v8/third_party/markupsafe")
    (buildpath/"third_party/fp16/src").install resource("v8/third_party/fp16/src")
    (buildpath/"third_party/googletest/src").install resource("v8/third_party/googletest/src")
    (buildpath/"third_party/icu").install resource("v8/third_party/icu")
    (buildpath/"third_party/zlib").install resource("v8/third_party/zlib")
    (buildpath/"third_party/abseil-cpp").install resource("v8/third_party/abseil-cpp")

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
      v8_enable_fuzztest:           false,
      v8_enable_i18n_support:       true,  # enables i18n support with icu
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
    else
      ENV["DEVELOPER_DIR"] = ENV["HOMEBREW_DEVELOPER_DIR"] # help run xcodebuild when xcode-select is set to CLT
      gn_args[:clang_base_path] = "\"#{Formula["llvm"].opt_prefix}\"" # uses Homebrew clang instead of Google clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture x86_64:
      #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from:
      #       std::__1::__throw_length_error[abi:nn180100](char const*) in stack_trace.o
      if DevelopmentTools.clang_build_version <= 1400
        gn_args[:fatal_linker_warnings] = false
        inreplace "build/config/mac/BUILD.gn", "[ \"-Wl,-ObjC\" ]",
                                               "[ \"-Wl,-ObjC\", \"-L#{Formula["llvm"].opt_lib}/c++\" ]"
      end
    end

    # Make sure private libraries can be found from lib
    ENV.prepend "LDFLAGS", "-Wl,-rpath,#{rpath(target: libexec)}"

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install libraries and headers into libexec so d8 can find them, and into standard directories
    # so other packages can find them and they are linked into HOMEBREW_PREFIX
    libexec.install "include"

    # Make sure we don't symlink non-headers into `include`.
    header_files_and_directories = (libexec/"include").children.select do |child|
      (child.extname == ".h") || child.directory?
    end
    include.install_symlink header_files_and_directories

    libexec.install "out.gn/d8", "out.gn/icudtl.dat"
    bin.write_exec_script libexec/"d8"

    libexec.install Pathname.glob("out.gn/#{shared_library("*")}")
    lib.install_symlink libexec.glob(shared_library("libv8*"))
    lib.glob("*.TOC").map(&:unlink) if OS.linux? # Remove symlinks to .so.TOC text files
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
    system ENV.cxx, "-std=c++20", "test.cpp",
                    "-I#{include}", "-L#{lib}",
                    "-Wl,-rpath,#{libexec}",
                    "-lv8", "-lv8_libplatform"
  end
end
