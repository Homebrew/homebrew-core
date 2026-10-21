class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://v8.dev/docs"
  # Track V8 version from Chrome stable: https://chromiumdash.appspot.com/releases?platform=Mac
  # Check `brew livecheck --resources v8` for any resource updates
  url "https://github.com/v8/v8/archive/refs/tags/15.6.75.19.tar.gz"
  sha256 "60c3dfdec757b51a7fab6b6b09bd3a559f40fed3bdeb5be1c6ee273a59517dd8"
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
    sha256 cellar: :any, arm64_golden_gate: "e96eeaf5e42570f58c6515b1eff9e152950fd5f7135fd0a5682fa0fc286b0215"
    sha256 cellar: :any, arm64_tahoe:       "5c83819ae3f9bbf6a3ec02516282d581135a2ce8776b2057fb922574191cd5c1"
    sha256 cellar: :any, arm64_sequoia:     "a0765114811c95a6b42c51f55e899bf253cc6e112c1f903fedf0751eb4a8a104"
    sha256 cellar: :any, arm64_linux:       "12a5b96e1be2b05dd899edf78a2d51088e925fa677f59cf328c075f1c0e2150c"
    sha256 cellar: :any, x86_64_linux:      "1af9d16d9b49f2a2ad98a3b549a92ef0602cf25de90e93254eca8df960be3820"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on xcode: ["10.0", :build] # for xcodebuild, min version required by v8
  end

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
  # e.g. for CIPD dependency gn: https://chromium.googlesource.com/v8/v8.git/+/refs/tags/<version>/DEPS#99
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "127dd2a6d582528d6d61c4d838dc17385ef31abd"
    version "127dd2a6d582528d6d61c4d838dc17385ef31abd"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(/["']gn_version["']:\s*["']git_revision:([0-9a-f]+)["']/i)
    end
  end

  resource "build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "bc0661cf80717e97e1b6868396f61f7f94f2d04a"
    version "bc0661cf80717e97e1b6868396f61f7f94f2d04a"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/build\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/src/buildtools.git",
        revision: "c202b4a9dac30e789ed6e3b2354efa94357a56f3"
    version "c202b4a9dac30e789ed6e3b2354efa94357a56f3"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/buildtools\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/abseil-cpp" do
    url "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp.git",
        revision: "edf0931ff4e2cddfeecade307ae948b5d09b8b38"
    version "edf0931ff4e2cddfeecade307ae948b5d09b8b38"

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
        revision: "b0ab987b3dfdde13fa1915f65ef2a5c068d9208c"
    version "b0ab987b3dfdde13fa1915f65ef2a5c068d9208c"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/fastfloat/fast_float\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/fp16/src" do
    url "https://chromium.googlesource.com/external/github.com/Maratyszcza/FP16.git",
        revision: "782eea126dc5c755827be751a099eb01826175cf"
    version "782eea126dc5c755827be751a099eb01826175cf"

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
        revision: "2607d3b5b0113992fe84d3848859eae13b3b52c1"
    version "2607d3b5b0113992fe84d3848859eae13b3b52c1"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/google/highway\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  resource "third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "5aa526207171ecadf31597f0980a7b7ad8872f33"
    version "5aa526207171ecadf31597f0980a7b7ad8872f33"

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

  resource "third_party/llvm-libc/src" do
    url "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libc.git",
        revision: "5e61624667bf9e44ea452191dbda0172997018a2"
    version "5e61624667bf9e44ea452191dbda0172997018a2"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/external/github.com/llvm/llvm-project/libc\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
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
        revision: "a0f30e381c6e132215a0c8d809fd08ff4cdad244"
    version "a0f30e381c6e132215a0c8d809fd08ff4cdad244"

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
        revision: "13395eebe853e811d274f7bd9b71fb7d9b5a5851"
    version "13395eebe853e811d274f7bd9b71fb7d9b5a5851"

    livecheck do
      url "https://raw.githubusercontent.com/v8/v8/refs/tags/#{LATEST_VERSION}/DEPS"
      regex(%r{["']/chromium/src/third_party/zlib\.git["']\s*\+\s*["']@["']\s*\+\s*["']([0-9a-f]+)["']}i)
    end
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }

    # `internal_allocator_forward.h` uses `size_t` without <cstddef>, which libstdc++ doesn't provide via <new>.
    # Remove when partition_alloc includes it.
    inreplace "third_party/partition_alloc/src/partition_alloc/internal_allocator_forward.h",
              "#include <new>\n", "#include <cstddef>\n#include <new>\n"

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
      is_debug:                      false,
      is_component_build:            true,
      v8_use_external_startup_data:  false,
      v8_enable_fuzztest:            false,
      v8_enable_i18n_support:        true,  # enables i18n support with icu
      clang_use_chrome_plugins:      false, # disable the usage of Google's custom clang plugins
      treat_warnings_as_errors:      false, # ignore not yet supported clang argument warnings
      # disable options which require Google's custom libc++
      use_custom_libcxx:             false,
      enable_rust:                   false,
      use_sysroot:                   false,
      v8_enable_temporal_support:    false,
      v8_enable_sandbox:             false, # sandbox is not supported by use_custom_libcxx: false
      v8_use_metagen_instance_types: false, # metagen needs the unvendored `llvm-libclang`
    }

    # uses Homebrew clang instead of Google clang
    llvm = Formula["llvm"]
    gn_args[:clang_base_path] = "\"#{llvm.opt_prefix}\""
    gn_args[:clang_version] = "\"#{llvm.version.major}\""

    if OS.linux?
      ENV["AR"] = llvm.opt_bin/"llvm-ar"
      ENV["NM"] = llvm.opt_bin/"llvm-nm"
      # unbundle toolchain uses separate host toolchain and reads BUILD_* variables
      ENV["BUILD_CC"]  = ENV["CC"]
      ENV["BUILD_CXX"] = ENV["CXX"]
      ENV["BUILD_AR"]  = ENV["AR"]
      ENV["BUILD_NM"]  = ENV["NM"]
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

    # Build with gn + ninja, using system Python instead of the hermetic CPython CIPD package
    system "gn", "gen", "--args=#{gn_args_string}", "--script-executable=python3", "out.gn"
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

    # link against installed libc++; V8 15.4 headers require the CppGC microtask queue define
    system ENV.cxx, "-std=c++20", "-DV8_CPPGC_MICROTASK_QUEUE", "test.cpp",
                    "-I#{include}", "-L#{lib}",
                    "-Wl,-rpath,#{libexec}",
                    "-lv8", "-lv8_libplatform"
  end
end
