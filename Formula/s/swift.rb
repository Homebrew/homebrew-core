class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
  sha256 "d63c9743fa1d35c8c6203745955375fd69c710897de96d1c6245d2c9e42fbb49"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(/swift[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35b2ce7246acacfeea4a7a377c865c9185e059eeb0d5a3d39133cbf13021963c"
    sha256 cellar: :any,                 arm64_monterey: "914cd349b8f0cb6f0c2c984f606a744a431f874f22a670f4d04b8249ed3819f7"
    sha256 cellar: :any,                 arm64_big_sur:  "2e165fd763a602bce118aaae3a92d7edf719c61de8ad41aeccad553d6df8da73"
    sha256 cellar: :any,                 ventura:        "b89f0ae6fc3736acb146fc6f91e500c1a044d6ee0947475c20b22326abdacbe5"
    sha256 cellar: :any,                 monterey:       "dc265ad2bdf088e34bd9d0ca826ccf59ede6a5538d4fd485908e3e7ec467b728"
    sha256 cellar: :any,                 big_sur:        "6db009f0cedd51ed5355046870ec843b2c9a71eb5c37b41d0b4bfcb23cc024f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5856963e79848044fa78280760a45bfb494a868fb21dd9d1d06d7a19564cf7e8"
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

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
      sha256 "9835efe51b78c329042e32b2b1bd82a0816535ca08687a30c0787091cdd40884"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
      sha256 "bcccde91987982dca285a5c73efa0922135b6caca07bc9e5a33333b0aa869db2"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
      sha256 "8d4cbffba2f828033a0074682d1bedd7a55d6410b6a30ca1e7c69917ab9352fe"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "3cd34ef37dd74a6d4d93be20fb251658e9a1e3c19aeeefd81c027023c485e286"

    # Fix finding Homebrew Python executable on Linux.
    # Remove with Swift 5.10+.
    patch do
      url "https://github.com/apple/llvm-project/commit/9e84e038447e283d020ae01aebb15e0e66ef3642.patch?full_index=1"
      sha256 "a46a6e9bf5309c1cb9c387e9648c6604a60f9cb3880463993ed72df4404f14ca"
    end
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "33dde8fc9e02a882d2adc79f1b7b77ae6397a66c73262bbdc3b49c53ab823b01"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "eeff879bc19de21aed72a747602212dff8ffe25833880c466a44087ffe2ed1ac"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "8e08b39fd7eb5329539514358d470bd84218a8b4ce53962d7fe3797f51adf59b"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "0789b254455e6f216b8d907ebc8fe5927106ae3a7a099d6478bbb9e6fac9b9fb"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "0fd130c814a35b3ba2b6b6d01979923fd57b3f453d154860ec2f53f9ade38023"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "4fc7965cd477daf61ff2d5b555007a195dc601e9864ee6d494826a7aa7ff31c7"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "e261dfdfc964a770c545c66267108c77692d06977c0d0bb437498f79ec23365c"
  end

  resource "swift-docc" do
    url "https://github.com/apple/swift-docc/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "3f8ab54cc6e20e70481caf8def2e9f3d0a596d2a564b9d5ebbe2ea9f0e3884b1"
  end

  resource "swift-lmdb" do
    url "https://github.com/apple/swift-lmdb/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "b201dcc044af95936b324fe83780156313c609f136417c01716712175ec9f9d6"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/apple/swift-docc-render-artifact/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "fc375c3e8d851bd2dfb1e0a5b03f2f98fa42e531d8bb8fe316581c4bd457d53c"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/apple/swift-docc-symbolkit/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "aa16774867c2e2eb2d7bc55349eca9ca27b6db3e2f16a6240269198cb865c898"
  end

  resource "swift-markdown" do
    url "https://github.com/apple/swift-markdown/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "aaf122834f7e0370107a404f5ef211969d1a44c9245407ff6971bdc509d8fb84"
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/apple/swift-experimental-string-processing/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "a01b2f895d49c23a4d322bfd486d4a7dcfeb96760d9c17f2e48b93428220b9ee"
  end

  resource "swift-syntax" do
    url "https://github.com/apple/swift-syntax/archive/refs/tags/swift-5.9.1-RELEASE.tar.gz"
    sha256 "b2ab10adcfbaebdd56954f724856d6ddd327422b4109d49ec5fb96b92b078003"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.2.2.tar.gz"
    sha256 "44782ba7180f924f72661b8f457c268929ccd20441eac17301f18eff3b91ce0c"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https://github.com/apple/swift-atomics/archive/refs/tags/1.0.2.tar.gz"
    sha256 "c8b88186db4902dc5109340f4a745ea787cb2aa9533c7e6d1e634549f9e527b1"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https://github.com/apple/swift-collections/archive/refs/tags/1.0.1.tar.gz"
    sha256 "575cf0f88d9068411f9acc6e3ca5d542bef1cc9e87dc5d69f7b5a1d5aec8c6b6"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https://github.com/apple/swift-crypto/archive/refs/tags/2.5.0.tar.gz"
    sha256 "a7b2f5c4887ccd728cdff5d1162b4d4d36bd6c2df9c0c31d5b9b73d341c5c1bb"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-certificates" do
    url "https://github.com/apple/swift-certificates/archive/refs/tags/0.4.1.tar.gz"
    sha256 "d7699ce91d65a622c1b9aaa0235cbbbd1be4ddc42a90fce007ff74bef50e8985"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-asn1" do
    url "https://github.com/apple/swift-asn1/archive/refs/tags/0.7.0.tar.gz"
    sha256 "d4470d61788194abbd60ed73965ee0722cc25037e83d41226a8a780088ba524e"
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
        # Backtracking currently requires stdlib - we may revisit in the future if part of the OS
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
          --skip-early-swift-driver
          --skip-early-swiftsyntax

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

        ENV["CMAKE_Swift_COMPILER"] = "" # Ignore our shim
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
    system "#{bin}/swiftc", "-module-cache-path", module_cache, "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test")
    assert_match "www.swift.org\n", output

    # Test Swift Package Manager
    ENV["SWIFTPM_MODULECACHE_OVERRIDE"] = module_cache
    mkdir "swiftpmtest" do
      system "#{bin}/swift", "package", "init", "--type=executable"
      cp "../foundation-test.swift", "Sources/main.swift"
      system "#{bin}/swift", "build", "--verbose", "--disable-sandbox"
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
