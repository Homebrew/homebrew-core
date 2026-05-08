class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://v8.dev/docs"
  # Track V8 version from Chrome stable: https://chromiumdash.appspot.com/releases?platform=Mac
  # Check `brew livecheck --resources v8` for any resource updates
  url "https://github.com/v8/v8/archive/refs/tags/14.8.178.14.tar.gz"
  sha256 "b799f3222200d5cab73aecc4cb47e4e5f53ee8679592bc55f2c3c7eeb99bdd36"
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
    sha256 cellar: :any,                 arm64_tahoe:   "f7c89ad8718c0b671dbf5965b56b15ec4b926061f1aa83ab4b8c8e57ef29f7f3"
    sha256 cellar: :any,                 arm64_sequoia: "34e06d455ac37f8d68e21129c829a2bd0e5556e136e6e5aa4e3b44698f36bbce"
    sha256 cellar: :any,                 arm64_sonoma:  "3e8fe9d39bfb2d9326e6133ad62eb5c2531173a6fb563ec326d7e13724c36fb8"
    sha256 cellar: :any,                 sonoma:        "b0685d8b5728f266927e2c0454d234fbeb15da23717e7301acab54de62d82dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b4e160189d3715c5bd747f8170ae64c0b1aecd53a94ad4e91daffd110628ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad83896b04944bb78014b366747560c987883a3ad4642160ee721d2d7c680d0a"
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

  fails_with :clang do
    cause "Apple Clang frequently breaks as upstream often uses features from newer Clang"
  end

  fails_with :gcc do
    cause "requires Clang"
  end

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/<version>/DEPS#74
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "6e8dcdebbadf4f8aa75e6a4b6e0bdf89dce1513a"
    version "6e8dcdebbadf4f8aa75e6a4b6e0bdf89dce1513a"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']gn_version["']:\s*["']git_revision:([0-9a-f]+)["']/i)
    end
  end

  resource "build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "9b7e5bb55b71044930fcf31b3fe531ad63151813"
    version "9b7e5bb55b71044930fcf31b3fe531ad63151813"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/build\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/src/buildtools.git",
        revision: "22e55595e15ebbbbb4bef118d5a654b185b0b30d"
    version "22e55595e15ebbbbb4bef118d5a654b185b0b30d"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/buildtools\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/abseil-cpp" do
    url "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp.git",
        revision: "2a7d49fc392cad55159d68d98aa3648bc89795d3"
    version "2a7d49fc392cad55159d68d98aa3648bc89795d3"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/abseil-cpp\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/dragonbox/src" do
    url "https://chromium.googlesource.com/external/github.com/jk-jeon/dragonbox.git",
        revision: "beeeef91cf6fef89a4d4ba5e95d47ca64ccb3a44"
    version "beeeef91cf6fef89a4d4ba5e95d47ca64ccb3a44"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github\.com/jk-jeon/dragonbox\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
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
        revision: "3d2de1816307bac63c16a297e8c4dc501b4076df"
    version "3d2de1816307bac63c16a297e8c4dc501b4076df"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/Maratyszcza/FP16\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "4fe3307fb2d9f86d19777c7eb0e4809e9694dde7"
    version "4fe3307fb2d9f86d19777c7eb0e4809e9694dde7"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/googletest\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/highway/src" do
    url "https://chromium.googlesource.com/external/github.com/google/highway.git",
        revision: "84379d1c73de9681b54fbe1c035a23c7bd5d272d"
    version "84379d1c73de9681b54fbe1c035a23c7bd5d272d"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/highway\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "ee5f27adc28bd3f15b2c293f726d14d2e336cbd5"
    version "ee5f27adc28bd3f15b2c293f726d14d2e336cbd5"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/deps/icu\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "c3027d884967773057bf74b957e3fea87e5df4d7"
    version "c3027d884967773057bf74b957e3fea87e5df4d7"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/jinja2\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "4256084ae14175d38a3ff7d739dca83ae49ccec6"
    version "4256084ae14175d38a3ff7d739dca83ae49ccec6"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/markupsafe\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/partition_alloc" do
    url "https://chromium.googlesource.com/chromium/src/base/allocator/partition_allocator.git",
        revision: "b707a2ca5567b06f4b886fbcd888dfa7e8044718"
    version "b707a2ca5567b06f4b886fbcd888dfa7e8044718"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']partition_alloc_version["']:\s*["']([0-9a-f]+)["']/i)
    end
  end

  resource "third_party/simdutf" do
    url "https://chromium.googlesource.com/chromium/src/third_party/simdutf.git",
        revision: "f7356eed293f8208c40b3c1b344a50bd70971983"
    version "f7356eed293f8208c40b3c1b344a50bd70971983"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/simdutf["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "b80f1d1e5256ac25f6aea3f31f13d458981cb1f9"
    version "b80f1d1e5256ac25f6aea3f31f13d458981cb1f9"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/zlib\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }

    inreplace buildpath/"build/config/compiler/BUILD.gn" do |s|
      # GCC only flag, not supported by clang
      s.gsub! "cflags += [ \"-fno-lifetime-dse\" ]", ""
      # Drop Chromium clang flags that upstream LLVM does not (yet) recognize.
      # TODO: Check this flags are supported by newer llvm
      s.gsub! "\"-fsanitize-ignore-for-ubsan-feature=array-bounds\",", ""
      s.gsub! "\"-fsanitize-ignore-for-ubsan-feature=return\",", ""
    end

    # Public headers reference unqualified `nullptr_t`; libstdc++ rejects this.
    # Remove in next release
    # ref: https://chromium.googlesource.com/v8/v8/+/6bb04495264b714767107d2bba9a53e42bc30702
    inreplace %w[include/v8-object.h include/v8-template.h],
              /(?<!::|std::)\bnullptr_t\b/, "std::nullptr_t"

    # `bigint.h` uses `std::unique_ptr` but never includes <memory>.
    # Remove in next release
    # ref: https://chromium.googlesource.com/v8/v8/+/4f9f652d6d4dd16a54ceb978069fb991ecef8fbc
    inreplace "src/bigint/bigint.h",
              "#include <utility>",
              "#include <memory>\n#include <utility>"

    # libstdc++ can't deduce the template parameter for `value_or({})`.
    # Remove in next release
    # ref: https://chromium.googlesource.com/v8/v8/+/913f679d5a4a3c4d0c6916cbdd065569945dc2a6
    inreplace "src/compiler/turboshaft/wasm-shuffle-reducer.cc",
              "max.value_or({})", "max.value_or(uint8_t{})"

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
      treat_warnings_as_errors:     false, # ignore not yet supported clang argument warnings
      # disable options which require Google's custom libc++
      use_custom_libcxx:            false,
      enable_rust:                  false,
      use_sysroot:                  false,
      v8_enable_temporal_support:   false,
      v8_enable_sandbox:            false, # sandbox is not supported by use_custom_libcxx: false
    }

    # uses Homebrew clang instead of Google clang
    llvm = Formula["llvm"]
    gn_args[:clang_base_path] = "\"#{llvm.opt_prefix}\""
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
