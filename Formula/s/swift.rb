class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
  sha256 "874c3b6668fb138db35c9f1c63570dafacac8476a6094b17764a51a45a1b69a2"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(/swift[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c74be5c5c48ca2acfdf542419029c94d96e2002c76a346d02bb9d6c8f48d3375"
    sha256 cellar: :any,                 arm64_ventura:  "5f5c949c95e858057004eced39eb3153fd7cf5064fba72b29b9b5fc87fec9733"
    sha256 cellar: :any,                 arm64_monterey: "9104796fd13c4e4de54314d6da2157b45a31f1346e2b4ef83d400020c084fcd6"
    sha256 cellar: :any,                 sonoma:         "5b32af755f0f4fbfb9cf53581d6b158b50e97023b1c08298aca4165b64c3985d"
    sha256 cellar: :any,                 ventura:        "8c6f474a5589efee56ca9b6e84eeebc6749d73bb090f23f3ba985e8887f7a8e4"
    sha256 cellar: :any,                 monterey:       "59e4d847eda70bba498876d057e86a5a31f1cfc08207a95abc5c5c93bd80acce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672dfc9f04c958666ec0ac30ad48f4ee0d76b8ccac1ff11e3c6c16cbc9fef0e1"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # As a starting point, check `minimum_version` in `validate_xcode_compatibility`:
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE/utils/build-script
  # This is community-sourced so may not be accurate. If the version in this formula
  # is higher then that is likely why.
  depends_on xcode: ["13.3", :build]

  depends_on "python@3.11"

  # HACK: this should not be a test dependency but is due to a limitation with fails_with
  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "rsync" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "icu4c" # Used in swift-corelibs-foundation

    # Doesn't have to be in sync but does need to be no older than X.(Y - 1).0
    resource "bootstrap" do
      on_intel do
        url "https://download.swift.org/swift-5.9.2-release/ubuntu2204/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu22.04.tar.gz"
        sha256 "6407e39eed7eaefcf7837d192d71765fb0f7cf8bf282c35b021171e8b15617c1"
      end

      on_arm do
        url "https://download.swift.org/swift-5.9.2-release/ubuntu2204-aarch64/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu22.04-aarch64.tar.gz"
        sha256 "942e58de3384c9ca57f9e136be4fab7a7e799ee3269c70f35d60b3fee0f1e2fe"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
      sha256 "e25700bffc439b36c5c9acf169332c0dd9805fcd91cd570b4ce96163b70bae5b"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
      sha256 "16e088cf12654d22658879710b9694a6fad1c94d5e5d0c597741b71fbcb3e034"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
      sha256 "b298316185270ac43ecdaf4c2fbd4329af51a18b174650510d7526238e9ca6fa"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "107e88150257e0c12333b4c43baa371a4252118e4977a69f5a16c566ee9f2cd3"

    # Fix finding Homebrew Python executable on Linux.
    # Remove with Swift 6.0.
    patch do
      url "https://github.com/apple/llvm-project/commit/9e84e038447e283d020ae01aebb15e0e66ef3642.patch?full_index=1"
      sha256 "a46a6e9bf5309c1cb9c387e9648c6604a60f9cb3880463993ed72df4404f14ca"
    end
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "6b7377e78b59410f8f3993cd6b83fe35fd097369a5cf89aa77c0e8b86d2218ee"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "ae8962d59244abac157c02813d05e1c077915bbd6022fe9fb62040806ac8dc55"

    # Workaround Homebrew sqlite3 not being found.
    # Needs paired inreplace for @@HOMEBREW_PREFIX@@.
    # https://github.com/apple/swift-llbuild/issues/901
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0080c7317c51d16b17671640c5db665516402d2f/swift/llbuild-sqlite3.patch"
      sha256 "97329a525dabf4a7a13d3e3237965e66ae456887776e0101e82b6ca125a97591"
    end
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "857391656ef94e7ef249b5d05d6a4226c2ec070ddbdd182d7dac92de748ff526"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "b701755b9ecef2363b8f91ad3d1f8677d78f06e81857a10de9a835c72176c241"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "e69f11068546ba1ee0015c68d3dbde0d053f1574ca643dd8d43e1d9dbc4cb2d7"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "51a48f1f277f4c5f87b8e1f08668e99ecd74f9fbee359ccde502cbb839eb7128"

    # Revert change that made Swift not respect SDKROOT.
    # Remove with Swift 6.0.
    patch do
      url "https://github.com/apple/swift-driver/commit/ef730dba907fc78bed3ab9f2a40d0ea2de1ccb2b.patch?full_index=1"
      sha256 "345dee5546c1632a7bfdcafc06354db0077ac1483719857018fa0b771de6c80c"
    end
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "36bb714e46966bdc48e9835e9440508f30f6c9d0b4479a1cebae0ab9f5952bb9"

    # Fix "close error" when compiling SwiftPM.
    # https://github.com/apple/swift-tools-support-core/pull/456
    patch do
      url "https://github.com/Bo98/swift-tools-support-core/commit/151e8fbd599a440c9931eae2a92221dd6d448dc6.patch?full_index=1"
      sha256 "d17f14ac12abcad3169d736665f43e3fef0c7a15a4812bb04c3b2237da0dfa19"
    end
  end

  resource "swift-docc" do
    url "https://github.com/apple/swift-docc/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "76228ac8de50d31685d28473f0eaa9c8859b40726f9b92cf3f6a675e6c53e9de"
  end

  resource "swift-lmdb" do
    url "https://github.com/apple/swift-lmdb/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "44b2ccc9e89eab003cc631a84e9569d4563e2dc4cca673fc7a465fd0fb4dbc6c"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/apple/swift-docc-render-artifact/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "2720c730199b910ed3808accc6f0c105bf35247578504fb1b4b0632bc7d346d8"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/apple/swift-docc-symbolkit/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "de1d4b6940468ddb53b89df7aa1a81323b9712775b0e33e8254fa0f6f7469a97"
  end

  resource "swift-markdown" do
    url "https://github.com/apple/swift-markdown/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "33104f65f31a19d3adfa5e32c7fc00b0e6f9f846bcc66f85ed7e7d6405fd87cc"
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/apple/swift-experimental-string-processing/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "542fa52af41287772ff36a18f4a8971e0aec07dbf4c59400e6d3422ab42d46df"
  end

  resource "swift-syntax" do
    url "https://github.com/apple/swift-syntax/archive/refs/tags/swift-5.10-RELEASE.tar.gz"
    sha256 "bec161cf707758d34d208c8e00bc338603094b489a9388caff79db1af3af20c7"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.2.3.tar.gz"
    sha256 "4a10bbef290a2167c5cc340b39f1f7ff6a8cf4e1b5433b68548bf5f1e542e908"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https://github.com/apple/swift-atomics/archive/refs/tags/1.0.2.tar.gz"
    sha256 "c8b88186db4902dc5109340f4a745ea787cb2aa9533c7e6d1e634549f9e527b1"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https://github.com/apple/swift-collections/archive/refs/tags/1.0.5.tar.gz"
    sha256 "d0f584b197860db26fd939175c9d1a7badfe7b89949b4bd52d4f626089776e0a"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https://github.com/apple/swift-crypto/archive/refs/tags/3.0.0.tar.gz"
    sha256 "5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-certificates" do
    url "https://github.com/apple/swift-certificates/archive/refs/tags/1.0.1.tar.gz"
    sha256 "fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-asn1" do
    url "https://github.com/apple/swift-asn1/archive/refs/tags/1.0.0.tar.gz"
    sha256 "e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-numerics" do
    url "https://github.com/apple/swift-numerics/archive/refs/tags/1.0.1.tar.gz"
    sha256 "3ff05bb89c907d70f51dfff794ea3354a2630488925bf53382246d25089ec742"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https://github.com/apple/swift-system/archive/refs/tags/1.1.1.tar.gz"
    sha256 "865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/refs/tags/5.0.1.tar.gz"
    sha256 "ec1ad699c30f0db45520006c63a88cc1c946a7d7b36dff32a96460388c0a4af2"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https://github.com/apple/swift-nio/archive/refs/tags/2.31.2.tar.gz"
    sha256 "8818b8e991d36e886b207ae1023fa43c5eada7d6a1951a52ad70f7f71f57d9fe"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio-ssl" do
    url "https://github.com/apple/swift-nio-ssl/archive/refs/tags/2.15.0.tar.gz"
    sha256 "9ab1f0e347fad651ed5ccadc13d54c4306e6f5cd21908a4ba7d1334278a4cd55"
  end

  # Homebrew-specific patch to make the default resource directory use opt rather than Cellar.
  # This fixes output binaries from `swiftc` having a runpath pointing to the Cellar.
  # This should only be removed if an alternative solution is implemented.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5e4d9bb4d04c7c9004e95fecba362a843dc00bdd/swift/homebrew-resource-dir.diff"
    sha256 "5210ca0fd95b960d596c058f5ac76412a6987d2badf5394856bb9e31d3c68833"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    install_prefix = if OS.mac?
      toolchain_prefix = "/Swift-#{version.major_minor}.xctoolchain"
      "#{toolchain_prefix}/usr"
    else
      "/libexec"
    end

    ln_sf buildpath, workspace/"swift"
    resources.each { |r| r.stage(workspace/r.name) }

    # Fix C++ header path. It wrongly assumes that it's relative to our shims.
    if OS.mac?
      inreplace workspace/"swift/utils/build-script-impl",
                "HOST_CXX_DIR=$(dirname \"${HOST_CXX}\")",
                "HOST_CXX_DIR=\"#{MacOS::Xcode.toolchain_path}/usr/bin\""
    end

    # Disable invoking SwiftPM in a sandbox while building some projects.
    # This conflicts with Homebrew's sandbox.
    helpers_using_swiftpm = [
      workspace/"indexstore-db/Utilities/build-script-helper.py",
      workspace/"sourcekit-lsp/Utilities/build-script-helper.py",
      workspace/"swift-docc/build-script-helper.py",
    ]
    inreplace helpers_using_swiftpm, "swiftpm_args = [", "\\0'--disable-sandbox',"
    inreplace workspace/"swift-docc/build-script-helper.py",
              "[swift_exec, 'package',",
              "\\0 '--disable-sandbox',"

    # Fix swift-driver somehow bypassing the shims.
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_C_COMPILER:=clang",
              "-DCMAKE_C_COMPILER:=#{which(ENV.cc)}"
    inreplace workspace/"swift-driver/Utilities/build-script-helper.py",
              "-DCMAKE_CXX_COMPILER:=clang++",
              "-DCMAKE_CXX_COMPILER:=#{which(ENV.cxx)}"

    # Build SwiftPM and dependents in release mode
    inreplace workspace/"swiftpm/Utilities/bootstrap",
              "-DCMAKE_BUILD_TYPE:=Debug",
              "-DCMAKE_BUILD_TYPE:=Release"

    # Fix lldb Python module not being installed (needed for `swift repl`)
    lldb_cmake_caches = [
      workspace/"llvm-project/lldb/cmake/caches/Apple-lldb-macOS.cmake",
      workspace/"llvm-project/lldb/cmake/caches/Apple-lldb-Linux.cmake",
    ]
    inreplace lldb_cmake_caches, "repl_swift", "lldb-python-scripts \\0"

    # Hack macOS 12 and lower support
    # Can remove with when this breaks (and we bump the min Xcode accordingly)
    inreplace [
      workspace/"swift-collections/Sources/OrderedCollections/HashTable/_HashTable+UnsafeHandle.swift",
      workspace/"swift-collections/Sources/OrderedCollections/Utilities/_UnsafeBitset.swift",
      workspace/"swift-certificates/Sources/X509/CertificateSerialNumber.swift",
    ], "swift(>=5.8)", 'canImport(Swift, _version: "5.8")'

    # Paired with llbuild patch
    inreplace workspace/"llbuild/Package.swift", "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    mkdir build do
      # List of components to build
      swift_components = %w[
        autolink-driver compiler clang-resource-dir-symlink
        libexec tools editor-integration toolchain-tools
        license sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers stdlib
        static-mirror-lib
      ]
      llvm_components = %w[
        llvm-ar llvm-cov llvm-profdata IndexStore
        clang clang-resource-headers compiler-rt
        clangd clang-features-file
      ]

      if OS.mac?
        swift_components << "back-deployment"
        llvm_components << "dsymutil"
      end
      if OS.linux?
        swift_components += %w[
          sdk-overlay
          sourcekit-inproc
        ]
        llvm_components << "lld"
      end

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --no-assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --swiftdocc --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --lldb-configure-tests=0
        --lldb-extra-cmake-args=-DPython3_EXECUTABLE=#{which("python3.11")}
        --skip-build-benchmarks
        --build-swift-private-stdlib=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-swiftpm
        --install-swift-driver
        --install-swiftsyntax
        --install-swiftdocc
        --install-sourcekit-lsp
      ]
      extra_cmake_options = []

      if OS.mac?
        # Backtracing currently requires stdlib - we may revisit in the future if part of the OS
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --build-swift-dynamic-stdlib=0
          --build-swift-dynamic-sdk-overlay=0
          --swift-enable-backtracing=0
          --stdlib-deployment-targets=
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --lldb-use-system-debugserver
        ]
        extra_cmake_options += %W[
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
          -DCMAKE_INSTALL_RPATH=#{loader_path}
        ]
      end
      if OS.linux?
        args += %W[
          --libcxx=0
          --foundation
          --libdispatch
          --xctest

          --host-target=linux-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --build-swift-static-stdlib
          --build-swift-static-sdk-overlay
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]
        rpaths = [loader_path, rpath, rpath(target: lib/"swift/linux")]
        extra_cmake_options << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(":")}"

        ENV.prepend_path "PATH", workspace/"bootstrap/usr/bin"
      end

      args << "--extra-cmake-options=#{extra_cmake_options.join(" ")}"

      system "#{workspace}/swift/utils/build-script", *args
    end

    if OS.mac?
      # Prebuild modules for faster first startup.
      ENV["SWIFT_EXEC"] = "#{prefix}#{install_prefix}/bin/swiftc"
      MacOS.sdk_locator.all_sdks.each do |sdk|
        next if sdk.version < :big_sur

        system "#{prefix}#{install_prefix}/bin/swift", "build-sdk-interfaces",
               "-sdk", sdk.path,
               "-o", "#{prefix}#{install_prefix}/lib/swift/macosx/prebuilt-modules",
               "-log-path", logs/"build-sdk-interfaces",
               "-v"
      end
    else
      # Strip debugging info to make the bottle relocatable.
      binaries_to_strip = Pathname.glob("#{prefix}#{install_prefix}/{bin,lib/swift/pm}/**/*").select do |f|
        f.file? && f.elf?
      end
      system "strip", "--strip-debug", "--preserve-dates", *binaries_to_strip
    end

    bin.install_symlink Dir["#{prefix}#{install_prefix}/bin/{swift,sil,sourcekit}*"]
    man1.install_symlink "#{prefix}#{install_prefix}/share/man/man1/swift.1"
    elisp.install_symlink "#{prefix}#{install_prefix}/share/emacs/site-lisp/swift-mode.el"
    doc.install_symlink Dir["#{prefix}#{install_prefix}/share/doc/swift/*"]

    rewrite_shebang detected_python_shebang, *Dir["#{prefix}#{install_prefix}/bin/*.py"]
  end

  def caveats
    on_macos do
      <<~EOS
        An Xcode toolchain has been installed to:
          #{opt_prefix}/Swift-#{version.major_minor}.xctoolchain

        This can be symlinked for use within Xcode:
          ln -s #{opt_prefix}/Swift-#{version.major_minor}.xctoolchain ~/Library/Developer/Toolchains/Swift-#{version.major_minor}.xctoolchain
      EOS
    end
  end

  test do
    # Don't use global cache which is long-lasting and often requires clearing.
    module_cache = testpath/"ModuleCache"
    module_cache.mkdir

    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'EOS'
      import Foundation

      let swifty = URLComponents(string: "https://www.swift.org")!
      print("\(swifty.host!)")
    EOS
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v foundation-test.swift")
    assert_match "www.swift.org\n", output

    # Test compiler
    system bin/"swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test")
    assert_match "www.swift.org\n", output

    # Test Swift Package Manager
    ENV["SWIFTPM_MODULECACHE_OVERRIDE"] = module_cache
    mkdir "swiftpmtest" do
      system bin/"swift", "package", "init", "--type=executable"
      cp "../foundation-test.swift", "Sources/main.swift"
      system bin/"swift", "build", "--verbose", "--disable-sandbox"
      assert_match "www.swift.org\n", shell_output("#{bin}/swift run --disable-sandbox")
    end

    # Make sure the default resource directory is not using a Cellar path
    default_resource_dir = JSON.parse(shell_output("#{bin}/swift -print-target-info"))["paths"]["runtimeResourcePath"]
    expected_resource_dir = if OS.mac?
      opt_prefix/"Swift-#{version.major_minor}.xctoolchain/usr/lib/swift"
    else
      opt_libexec/"lib/swift"
    end.to_s
    assert_equal expected_resource_dir, default_resource_dir
  end
end
