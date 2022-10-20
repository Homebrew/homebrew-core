class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
  sha256 "5385aa70a62d57087c4f34e5cde0f0154dc9e3916bf4ac95a21594433e7db5f8"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/swift[._-]v?(\d+(?:\.\d+)+)[^"' >]*?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "27fc4f9b3e6da956277755cb0d44341bed37edd39e4189041301afc9c434206f"
    sha256 cellar: :any,                 arm64_big_sur:  "7352c769002054aa1d11f8b4a51f3635a8fff633d2eea7877ac1f657b7df351d"
    sha256 cellar: :any,                 monterey:       "f37925bbc0f636c8ac5e55e66612a599ec6c865e2aa26d39d1bd56a2ad8b48e7"
    sha256 cellar: :any,                 big_sur:        "f628e21fcb52479ae8e7c529653ad734ce2d9ee61c1ba601c68d52ed6ccf0cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a683d46cd3255c9c6fcf24cda776e23e97ab0812a076a307689363f608290d59"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode. See _SUPPORTED_XCODE_BUILDS:
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE/utils/build-script
  # This is mostly community sourced, so may be not necessarily be accurate.
  depends_on xcode: ["13.0", :build]

  depends_on "python@3.10"

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
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
      sha256 "3a50954f6c821448dec94f3da51e6a101f8fba2ee3da8327637a9150f865411e"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
      sha256 "b8398571561f3e94053309c55029726af541180e3323ea68e3ca544bbdc57a10"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
      sha256 "c801bf4ca0727214036eb9aa2a8c27b6954b0063569147a4cc9d2a212b9ed9cf"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "0361c7d65344b7bcfea26cccf63387f137192e21268f84956de5be66a25ac7c9"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "1c49d849f4bc4664f88f2938bd8410f29e107b6ae51ef038599b23eae11b4325"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "048bfb7f8b3baece8fc3b4f30ed7a96619a7817c5dbe02976c087eafb610bcd3"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "9a6839811be8fc9de822244df96b54473cd847c87a6ff21e8016fc6f8da65a13"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "cee2355b7bc120b3a3fa7ecf00f54819aab298829547a629643d00c1add53269"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "e246a3320bd09845cf06b18beccbcf1b9994ee32616e9033f11a536c62d304d5"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "12a074d874866f76d3e58266c68cdb75d3c27ea07e529902783662ec4d495393"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "8c9d098f4c2420496fc480f8de3b8f4edb19fb29d78f63c1869073343ccdded7"
  end

  resource "swift-docc" do
    url "https://github.com/apple/swift-docc/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "5ed9c8ac955c12e68c318738ff57f810fb75702416d739d1e351c0861babc942"
  end

  resource "swift-lmdb" do
    url "https://github.com/apple/swift-lmdb/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "45241f1ccb94acea30c72fd70a3cd87f69a24c555765f59b2ecc7c947cf7456c"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/apple/swift-docc-render-artifact/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "6b83b15de65281c893ae59457f2cdcc2866e41dc42fc46f91903cd9413ad511e"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/apple/swift-docc-symbolkit/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "ce0bfd2861a649aeb3bc275df0f0dc67dcc4c7f8fe1ce1918fd42a52f33d592f"
  end

  resource "swift-markdown" do
    url "https://github.com/apple/swift-markdown/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "308914a171559f974859ba8553572c7aa1a9d85abdf1b9aff6214e3e60cf4cfc"
  end

  resource "swift-cmark-gfm" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.7-RELEASE-gfm.tar.gz"
    sha256 "802188f7dfe142ad9072343322fe9bf684607338b9e276b254af039ad292f2f7"
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/apple/swift-experimental-string-processing/archive/refs/tags/swift-5.7-RELEASE.tar.gz"
    sha256 "d7282d9cbded01dd944022ec1a6ad9e1157bb0aedd45f2baa7a5ea351dc95862"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.0.3.tar.gz"
    sha256 "a4d4c08cf280615fe6e00752ef60e28e76f07c25eb4706a9269bf38135cd9c3f"
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
    url "https://github.com/apple/swift-crypto/archive/refs/tags/1.1.5.tar.gz"
    sha256 "86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f"
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

    # Fix finding of brewed sqlite3.h.
    unless OS.mac?
      inreplace workspace/"swift-tools-support-core/Sources/TSCclibc/include/module.modulemap",
                "header \"csqlite3.h\"",
                "header \"#{Formula["sqlite3"].opt_include/"sqlite3.h"}\""
    end

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
        compiler clang-resource-dir-symlink tools
        editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib stdlib
        static-mirror-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
        clang-features-file
      ]

      if OS.mac?
        swift_components << "back-deployment"
        llvm_components << "dsymutil"
      end
      if OS.linux?
        swift_components += %w[
          sdk-overlay
          autolink-driver
          sourcekit-inproc
        ]
        llvm_components << "lld"
      end

      args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --assertions
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
        --install-swiftdocc
        --install-sourcekit-lsp
      ]
      extra_cmake_options = []

      if OS.mac?
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --darwin-deployment-version-osx=#{MacOS.version}
          --build-swift-dynamic-stdlib=0
          --build-swift-dynamic-sdk-overlay=0
          --stdlib-deployment-targets=
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --back-deploy-concurrency
          --install-back-deploy-concurrency
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

      ENV["SKIP_XCODE_VERSION_CHECK"] = "1"
      system "#{workspace}/swift/utils/build-script", *args
    end

    if OS.mac?
      # Prebuild modules for faster first startup.
      ENV["SWIFT_EXEC"] = "#{prefix}#{install_prefix}/bin/swiftc"
      MacOS.sdk_locator.all_sdks.each do |sdk|
        system "#{prefix}#{install_prefix}/bin/swift-build-sdk-interfaces",
               "-sdk", sdk.path,
               "-o", "#{prefix}#{install_prefix}/lib/swift/macosx/prebuilt-modules",
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
      # Swift Package Manager does not currently support using SDKROOT.
      ENV.remove_macosxsdk if OS.mac?

      system "#{bin}/swift", "package", "init", "--type=executable"
      rm "Sources/swiftpmtest/swiftpmtest.swift"
      cp "../foundation-test.swift", "Sources/swiftpmtest/main.swift"
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
