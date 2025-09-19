class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://v8.dev/docs"
  # Track V8 version from Chrome stable: https://chromiumdash.appspot.com/releases?platform=Mac
  # Check `brew livecheck --resources v8` for any resource updates
  url "https://github.com/v8/v8/archive/refs/tags/13.5.212.10.tar.gz"
  sha256 "2c47b3de22591f4384f75aa462301eb9fdb9d661ee07f73cab95a89d0a75d5ae"
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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "608bb35f6b352cd6c1e10489fb301b6e826e8f97cb279d268a29829713924515"
    sha256 cellar: :any,                 arm64_sequoia: "72d470fd40a8a7c552ed76a235a593eae664619f2ff63433e4dd99d41ae7c496"
    sha256 cellar: :any,                 arm64_sonoma:  "042e5464470b5b353559ef4f50dcb118025f0969af15fc85025ed4c6202d9b3e"
    sha256 cellar: :any,                 sonoma:        "13d60cdca44d3f1b9a5ea1997981321169048a24f384691f349887d27eb480b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b07cbc0682b820d94953ef5fe2b3c5940f7ebc9fb6375c38172b446cd08455a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c443ea4ea031822f96fddc71f10a6d0a56f3f1ab39d57b1732963ee90a04b778"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on xcode: ["10.0", :build] # for xcodebuild, min version required by v8

  uses_from_macos "python" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "glib"
  end

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/<version>/DEPS#74
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "4a8016dc391553fa1644c0740cc04eaac844121e"
    version "4a8016dc391553fa1644c0740cc04eaac844121e"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']gn_version["']:\s*["']git_revision:([0-9a-f]+)["']/i)
    end
  end

  resource "build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "efb3303345a5501074564393470197a904b4afb7"
    version "efb3303345a5501074564393470197a904b4afb7"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/build\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/src/buildtools.git",
        revision: "b248db940ef3dd7e5f4694ebf4d8a3f67aa0086d"
    version "b248db940ef3dd7e5f4694ebf4d8a3f67aa0086d"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/buildtools\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/abseil-cpp" do
    url "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp.git",
        revision: "2705c6655c0008cc3fb152dae27890d44bc335f1"
    version "2705c6655c0008cc3fb152dae27890d44bc335f1"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/abseil-cpp\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/fast_float/src" do
    url "https://chromium.googlesource.com/external/github.com/fastfloat/fast_float.git",
        revision: "cb1d42aaa1e14b09e1452cfdef373d051b8c02a4"
    version "cb1d42aaa1e14b09e1452cfdef373d051b8c02a4"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/fastfloat/fast_float\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/fp16/src" do
    url "https://chromium.googlesource.com/external/github.com/Maratyszcza/FP16.git",
        revision: "0a92994d729ff76a58f692d3028ca1b64b145d91"
    version "0a92994d729ff76a58f692d3028ca1b64b145d91"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/Maratyszcza/FP16\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "24a9e940d481f992ba852599c78bb2217362847b"
    version "24a9e940d481f992ba852599c78bb2217362847b"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/googletest\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/highway/src" do
    url "https://chromium.googlesource.com/external/github.com/google/highway.git",
        revision: "00fe003dac355b979f36157f9407c7c46448958e"
    version "00fe003dac355b979f36157f9407c7c46448958e"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/highway\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "d30b7b0bb3829f2e220df403ed461a1ede78b774"
    version "d30b7b0bb3829f2e220df403ed461a1ede78b774"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/deps/icu\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "5e1ee241ab04b38889f8d517f2da8b3df7cfbd9a"
    version "5e1ee241ab04b38889f8d517f2da8b3df7cfbd9a"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/jinja2\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "9f8efc8637f847ab1ba984212598e6fb9cf1b3d4"
    version "9f8efc8637f847ab1ba984212598e6fb9cf1b3d4"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/markupsafe\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/partition_alloc" do
    url "https://chromium.googlesource.com/chromium/src/base/allocator/partition_allocator.git",
        revision: "46d880ff62f340854a5a70142b0abf604c7af221"
    version "46d880ff62f340854a5a70142b0abf604c7af221"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']partition_alloc_version["']:\s*["']([0-9a-f]+)["']/i)
    end
  end

  resource "third_party/simdutf" do
    url "https://chromium.googlesource.com/chromium/src/third_party/simdutf.git",
        revision: "5a9a2134b280c1b956ad68a0643797fe26dd1c94"
    version "5a9a2134b280c1b956ad68a0643797fe26dd1c94"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/simdutf["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "788cb3c270e8700b425c7bdca1f9ce6b0c1400a9"
    version "788cb3c270e8700b425c7bdca1f9ce6b0c1400a9"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/zlib\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }

    # Build gn from source and add it to the PATH
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    ENV.prepend_path "PATH", buildpath/"gn/out"

    # create gclient_args.gni
    (buildpath/"build/config/gclient_args.gni").write <<~GN
      declare_args() {
        checkout_google_benchmark = false
      }
    GN

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
    }

    # workaround to use shim to compile v8
    ENV.llvm_clang
    llvm = Formula["llvm"]
    clang_base_path = buildpath/"clang"
    clang_base_path.install_symlink (llvm.opt_prefix.children - [llvm.opt_bin])
    (clang_base_path/"bin").install_symlink llvm.opt_bin.children
    %w[clang clang++].each do |compiler|
      rm(clang_base_path/"bin"/compiler)
      (clang_base_path/"bin"/compiler).write_env_script Superenv.shims_path/"llvm_#{compiler}", _skip: ""
      chmod "+x", clang_base_path/"bin"/compiler
    end

    # uses Homebrew clang instead of Google clang
    gn_args[:clang_base_path] = "\"#{clang_base_path}\""
    gn_args[:clang_version] = "\"#{llvm.version.major}\""

    if OS.linux?
      ENV["AR"] = DevelopmentTools.locate("ar")
      ENV["NM"] = DevelopmentTools.locate("nm")
      gn_args[:use_sysroot] = false # don't use sysroot
      gn_args[:custom_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # uses system toolchain
      gn_args[:host_toolchain] = "\"//build/toolchain/linux/unbundle:default\"" # to respect passed LDFLAGS
      gn_args[:use_rbe] = false
    else
      ENV["DEVELOPER_DIR"] = ENV["HOMEBREW_DEVELOPER_DIR"] # help run xcodebuild when xcode-select is set to CLT
      gn_args[:use_lld] = false # upstream use LLD but this leads to build failure on ARM
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

    (testpath/"test.cpp").write <<~CPP
      #include <libplatform/libplatform.h>
      #include <v8.h>
      int main(){
        static std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
        v8::V8::InitializePlatform(platform.get());
        v8::V8::Initialize();
        return 0;
      }
    CPP

    # link against installed libc++
    system ENV.cxx, "-std=c++20", "test.cpp",
                    "-I#{include}", "-L#{lib}",
                    "-Wl,-rpath,#{libexec}",
                    "-lv8", "-lv8_libplatform"
  end
end
