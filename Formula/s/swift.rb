class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/swiftlang/swift/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
  sha256 "1f0a54a0ecbd19c7eabdd026f3986fd460905146c378859acb277e9c682d1faf"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(/swift[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f68e82e8fea45c4a8f65146eb98ec1e0f1418b6230c73888b9f478a38387672d"
    sha256 cellar: :any,                 arm64_sonoma:  "26de451fb88025fb13b1b92d9f50a7949a36b1401f526696321c73a2b7668f06"
    sha256 cellar: :any,                 arm64_ventura: "a1d9ce8a6b96748adab517f9b9f76daed8a713d3f2050b5854525b3f611c6748"
    sha256 cellar: :any,                 sonoma:        "45509e26cf31a30de0e5cf6e31c73d1031a402b2446bd645b0ed192e9b0ad1b7"
    sha256 cellar: :any,                 ventura:       "a440a437121c2e9aaba92681137e3b954cd45d5a03d23cf94d226a78fa937050"
    sha256                               arm64_linux:   "f91ffa53d6aed66eba8a29f5c082b88f5a0bd54653b123fdd5f80e6fb4044522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b990b642f94de06a0e7eed8fa0b36909d582f80ff2f2f93e140836b4d5c9dfcf"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # As a starting point, check `minimum_version` in `validate_xcode_compatibility`:
  # https://github.com/swiftlang/swift/tree/swift-#{version}-RELEASE/utils/build-script
  # This is community-sourced so may not be accurate. If the version in this formula
  # is higher then that is likely why.
  depends_on xcode: ["14.3", :build]

  depends_on "python@3.13"

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
    depends_on "python-setuptools" => :build # for distutils in lldb build
    depends_on "util-linux"
    depends_on "zstd" # implicit via curl; not important but might as well

    # Doesn't have to be in sync but does need to be no older than X.(Y - 1).0
    resource "bootstrap" do
      on_intel do
        url "https://download.swift.org/swift-6.0.3-release/ubuntu2204/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu22.04.tar.gz"
        sha256 "09d0a53fbddf2878673dd12c1504e7143c788f195caec9f2329740946eba525c"
      end

      on_arm do
        url "https://download.swift.org/swift-6.0.3-release/ubuntu2204-aarch64/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu22.04-aarch64.tar.gz"
        sha256 "0ce755e7ed16fa07f6d1207a8135aff97e977653c1359011c60cb6d85a9cfa5b"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
      sha256 "2028db635d8bfd5e27b75d8ae2048137b29fb18857b71743fcb8836b99b394b3"
    end

    resource "swift-foundation" do
      url "https://github.com/apple/swift-foundation/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
      sha256 "89ec1ea85b7278d87bea1098c1d20e7b28ee77527f558cc6983c6e5aed7f42cf"
    end

    resource "swift-foundation-icu" do
      url "https://github.com/apple/swift-foundation-icu/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
      sha256 "45a5f88a5fa18aabbab5ebb3fbb6b5ef081b896617714f5ee4d012a38a44e887"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
      sha256 "26e8f6d661415502c10f909835961cac4edf56a0ab9512a9988489fe98601385"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
      sha256 "ab608cb96edac4d1ea742c78f7eaae4710460af47f43ef4d97c9c0c99c64bf32"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/swiftlang/llvm-project/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "0f4ba9151057793da3d7beacfa71eab8c6545ef21e72826f369a500f36cf6c99"
  end

  resource "cmark" do
    url "https://github.com/swiftlang/swift-cmark/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "0a605e38075f02d2b45d88dc115f7934de6b96233d7211862476c9e86e2fa440"
  end

  resource "llbuild" do
    url "https://github.com/swiftlang/swift-llbuild/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "16a3b5d0e30fcc9b0b11f2c4b4a38676ea7428727c7017605a0ec4880a3a4f32"

    # Workaround Homebrew sqlite3 not being found.
    # Needs paired inreplace for @@HOMEBREW_PREFIX@@.
    # https://github.com/swiftlang/swift-llbuild/issues/901
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b793090731cb78488fef39d1d3a7441beefd487a/swift/llbuild-sqlite3.patch"
      sha256 "c98ad4ce880df7ce872936e9ff93d054faf8ed030298379d4836c20243b29c7d"
    end

    # Fix compatibility with CMake 4.0.
    # Remove with Swift 6.2.
    patch do
      url "https://github.com/swiftlang/swift-llbuild/commit/ae496d19026948835244e6734263697e3b445421.patch?full_index=1"
      sha256 "9dd805424730e535d3cde48ac26f01575cc81aee4a0074cff632a0d003c41b95"
    end
  end

  resource "swiftpm" do
    url "https://github.com/swiftlang/swift-package-manager/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "a3caae19178ef7c917b750fb4fc1c30710bcfba1fabcc43bf1fab9440b7a08a7"
  end

  resource "indexstore-db" do
    url "https://github.com/swiftlang/indexstore-db/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "ed7c446606b9651d82adf5a9304b58ebb607f5f50d63f699429b7288a8f2c214"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/swiftlang/sourcekit-lsp/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "51a575bd223767685cd9a4c7a0a8ccb3ed1b57118b5143b4bb64fd27d4487cb3"
  end

  resource "swift-driver" do
    url "https://github.com/swiftlang/swift-driver/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "67eb10f1c7a3d9e0e430b0882848eb563a928b810a5acd8442860820666c9061"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/swiftlang/swift-tools-support-core/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "0d79c074db534f3054fdfe40bde18effdb9ab9ef0a7930395f54a15ae67d5baf"

    # Fix "close error" when compiling SwiftPM.
    # https://github.com/swiftlang/swift-tools-support-core/pull/456
    patch do
      url "https://github.com/Bo98/swift-tools-support-core/commit/dca5ee70e302df065178cc8a75a2d6ea00886c40.patch?full_index=1"
      sha256 "e5e2e7cec7b7bd9ef0def5cfc9b1308fe1f25f6228973031c9821b2c4475c8a1"
    end
  end

  resource "swift-docc" do
    url "https://github.com/swiftlang/swift-docc/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "0df62a36e0cf30a7a7650fb3daea8f8ef00f434157fe83f22ec1705d40acaf05"
  end

  resource "swift-lmdb" do
    url "https://github.com/swiftlang/swift-lmdb/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "1f8eeeb1d1194a30ff5996f111032b0e67c14a98238ad753888c491035a3d076"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/swiftlang/swift-docc-render-artifact/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "9c6fc978e6df32a821b5795c1eafa10faea580bc84bdb36332c755795fa8f3db"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/swiftlang/swift-docc-symbolkit/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "df911bae592aaad51a0547f5ce3b6d2af16738718dc74a808503426f2c50ea29"
  end

  resource "swift-markdown" do
    url "https://github.com/swiftlang/swift-markdown/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "a4310d7c80dc6f441bd961fc57d88412d24bdf6847e9478bedf4b64936174ae0"
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/swiftlang/swift-experimental-string-processing/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "bb74c6a34e8ddcc3e0d57261b7fc4702db866110b4da806903e746ef663b6b03"
  end

  resource "swift-syntax" do
    url "https://github.com/swiftlang/swift-syntax/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "c81185169635156aa90cb847ca7b4dbcbf7b68970b5bfdd53200fb59e0a9cbb7"
  end

  resource "swift-testing" do
    url "https://github.com/swiftlang/swift-testing/archive/refs/tags/swift-6.1.2-RELEASE.tar.gz"
    sha256 "ee9fe0f384b6dc625911b124ad9b00f9fdad68650512fe10bfbd602f94a9d87d"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/swiftlang/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-toolchain-sqlite" do
    # Only actually used on Windows and Android, but the build unfortunately still requires this to be present.
    url "https://github.com/swiftlang/swift-toolchain-sqlite/archive/refs/tags/1.0.1.tar.gz"
    sha256 "c8704e70c4847a8dbd47aafb25d293fbe1e1bafade16cfa64e04f751e33db0ca"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.4.0.tar.gz"
    sha256 "d5bad3a1da66d9f4ceb0a347a197b8fdd243a91ff6b2d72b78efb052b9d6dd33"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https://github.com/apple/swift-atomics/archive/refs/tags/1.2.0.tar.gz"
    sha256 "33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https://github.com/apple/swift-collections/archive/refs/tags/1.1.3.tar.gz"
    sha256 "7e5e48d0dc2350bed5919be5cf60c485e72a30bd1f2baf718a619317677b91db"
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
    url "https://github.com/apple/swift-numerics/archive/refs/tags/1.0.2.tar.gz"
    sha256 "786291c6ff2a83567928d3d8f964c43ff59bdde215f9dedd0e9ed49eb5184e59"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https://github.com/apple/swift-system/archive/refs/tags/1.3.0.tar.gz"
    sha256 "02e13a7f77887c387f5aa1de05f4d4b8b158c35145450e1d9557d6c42b06cd1f"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/refs/tags/5.0.6.tar.gz"
    sha256 "a81c6b93f5d26bae1b619b7f8babbfe7c8abacf95b85916961d488888df886fb"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https://github.com/apple/swift-nio/archive/refs/tags/2.65.0.tar.gz"
    sha256 "feb16b6d0e6d010be14c6732d7b02ddbbdc15a22e3912903f08ef5d73928f90d"
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

    # Fix lldb Python module not being installed (needed for `swift repl`)
    inreplace workspace/"llvm-project/lldb/cmake/caches/Apple-lldb-macOS.cmake",
              "repl_swift",
              "lldb-python-scripts \\0"

    # Fix Linux RPATH for Swift Foundation
    if OS.linux?
      inreplace [
        workspace/"swift-corelibs-foundation/Sources/FoundationNetworking/CMakeLists.txt",
        workspace/"swift-corelibs-foundation/Sources/FoundationXML/CMakeLists.txt",
      ], '"$ORIGIN"', "\"$ORIGIN:#{ENV["HOMEBREW_RPATH_PATHS"]}\""
    end

    extra_cmake_options = if OS.mac?
      %W[
        -DSQLite3_INCLUDE_DIR=#{MacOS.sdk_for_formula(self).path}/usr/include
        -DSQLite3_LIBRARY=#{MacOS.sdk_for_formula(self).path}/usr/lib/libsqlite3.tbd
      ]
    else
      []
    end

    # Inject our CMake args into the SwiftPM build
    inreplace workspace/"swiftpm/Utilities/bootstrap",
              '"-DCMAKE_BUILD_TYPE:=Debug",',
              "\"-DCMAKE_BUILD_TYPE:=Release\", \"#{extra_cmake_options.join('", "')}\","

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
        llvm-ar llvm-ranlib llvm-cov llvm-profdata IndexStore
        clang clang-resource-headers compiler-rt
        clangd clang-features-file lld
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
      end

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --no-assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --swiftdocc --indexstore-db --sourcekit-lsp
        --swift-testing --swift-testing-macros
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --lldb-configure-tests=0
        --lldb-extra-cmake-args=-DPython3_EXECUTABLE=#{which("python3.13")}
        --skip-build-benchmarks
        --build-swift-private-stdlib=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-static-linux-config
        --install-swiftpm
        --install-swift-driver
        --install-swiftsyntax
        --install-swiftdocc
        --install-sourcekit-lsp
        --install-swift-testing
        --install-swift-testing-macros
      ]

      extra_cmake_options << "-DSWIFT_INCLUDE_TEST_BINARIES=OFF"

      if OS.mac?
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=x86_64;arm64
          --lldb-use-system-debugserver
        ]
        args << "--swift-enable-backtracing=0" if MacOS.version < :sonoma
        extra_cmake_options += %W[
          -DSWIFT_STANDARD_LIBRARY_SWIFT_FLAGS=-disable-sandbox
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=OFF
          -DSWIFT_HOST_LIBRARIES_RPATH=#{loader_path}
        ]

        ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["sqlite"].opt_lib
        ENV.remove "PKG_CONFIG_PATH", Formula["sqlite"].opt_lib/"pkgconfig"
      end
      if OS.linux?
        # List of valid values in class StdlibDeploymentTarget in
        # utils/swift_build_support/swift_build_support/targets.py
        arch = (Hardware::CPU.arm? && Hardware::CPU.is_64_bit?) ? "aarch64" : Hardware::CPU.arch

        args += %W[
          --libcxx=0
          --foundation
          --libdispatch
          --xctest

          --host-target=linux-#{arch}
          --stdlib-deployment-targets=linux-#{arch}
          --build-swift-static-stdlib
          --build-swift-static-sdk-overlay
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]

        # Use lld because gold is deprecated and might not be available on all distros.
        # But force the LLVM build itself to use system linker as it builds lld too late.
        # This might be fixed in Swift 6.3 when it moves to use LLVM_ENABLE_RUNTIMES.
        args << "--llvm-cmake-options=-DCLANG_DEFAULT_LINKER=lld -DLLVM_USE_LINKER=ld"

        # For XCTest (https://github.com/swiftlang/swift-corelibs-xctest/issues/432) and sourcekitd-repl
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

    (testpath/"test.swift").write <<~'SWIFT'
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
    SWIFT
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'SWIFT'
      import Foundation

      let swifty = URLComponents(string: "https://www.swift.org")!
      print("\(swifty.host!)")
    SWIFT
    output = shell_output("#{bin}/swift -module-cache-path #{module_cache} -v foundation-test.swift")
    assert_match "www.swift.org\n", output

    # Test compiler
    system bin/"swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test 2>&1") # check stderr too for dyld errors
    assert_equal "www.swift.org\n", output

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
