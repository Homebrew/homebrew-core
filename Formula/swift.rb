class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
  sha256 "ba76a631b634efebfc5aa01942ab9371e7574f6d69eb08942bbefe04116f039c"
  license "Apache-2.0"

  # This uses the `GithubLatest` strategy because a `-RELEASE` tag is often
  # created several days before the version is officially released.
  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/swift[._-]v?(\d+(?:\.\d+)+)[^"' >]*?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "690808aadd61bf4dd990be508d1af6cd583192f1e5341afa2fc85a1c612e936e"
    sha256 cellar: :any,                 arm64_big_sur:  "6ff1e5aa199df74e95da9b7db917c23110a6e8fa0b23c4866541e3a228488277"
    sha256 cellar: :any,                 monterey:       "39e33104563e2160ce6976a376110447fed740c0df3957841e2f9909f0e71912"
    sha256 cellar: :any,                 big_sur:        "5c684b62fec4dea6d91cb4d698baf48bd667b573096680acf9ef4e8572d20609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272fa45941167ad143340d1bfd0ddf0546483ebca36cb2310d24ec118dbb483e"
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
    depends_on "six" => :build # Remove with Swift 5.7.
    depends_on "icu4c" # Used in swift-corelibs-foundation

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
      sha256 "33c27428d29092cbd214d8e8e6f281fffc28f4557f10366e4f6f3ac45b34c315"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
      sha256 "e71ebdc2bd573de3af2777816e0f034f29cf16b42025ab3b95e15c71159bab5c"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
      sha256 "c5ced7851691ce8b30e333fe49aa94c448cb86e502d49f9921a9679a530a7a2d"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "4e414881b7f405a537014ad09004e0b4b4ed29480d8b82da6fbfc8a0d16feaa9"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "a950b87ee3165d311d440c688132c42066d4915280df6e80a1a505a942b1dc28"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "4b2f230cc1f0a5857717715ddfe7f532d434311c76801c65ca1ad8ace4a9ad18"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "420491446bf25409169c621955c2901d2edc11844834acc32f5311d6b719ef51"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "0eb0e73ecab6d4c7d8e9cc4ade8d83e31a406070e0a655afb3a9b0d4dc50f3d7"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "497432deb1ee6fc004196b2240fc6a1bb83d6590fef83d97193b3bc4b41ab62c"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "a317d194e0eb1c39fd28644597c8dfe4c89cd611fe8ca9cc8765551994583879"

    # Fix compatibility with Python 3 on macOS.
    # Remove with Swift 5.7.
    patch do
      url "https://github.com/apple/swift-driver/commit/1153cb9fa789592f20d6422e7987a2fd9c32f113.patch?full_index=1"
      sha256 "228f1808b5b002b8e1db76f727de39a9a8b9984bce8f56feb57c1b6530f3526a"
    end
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "171235636aaa3a82a2a47dfd1a9e493dc034d3f929e64200544f714750076ea3"
  end

  resource "swift-docc" do
    url "https://github.com/apple/swift-docc/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "ac1f1fe21d677c14d6fe4e3626de6bf363ae817bdae4bf3b6436c6816aaee281"

    # Fix build with newer Pythons.
    # Remove with Swift 5.7.
    patch do
      url "https://github.com/apple/swift-docc/commit/bff70b847008f91ac729cfd299a85481eef3f581.patch?full_index=1"
      sha256 "b3378f7ed6042baa4889f37445221b6dd6cd6828f7db4b66707d361bc30477ca"
    end
  end

  resource "swift-lmdb" do
    url "https://github.com/apple/swift-lmdb/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "1a43bd9bcbd57036348106d95457ca73c5a7387ba497cf9f2ff572d084b24e9c"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/apple/swift-docc-render-artifact/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "ef76838ca76ea0c38df46015f2077b19bab68e8fa58d85361ede697ad7379807"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/apple/swift-docc-symbolkit/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "335c5626c708152a83f4201c76b741a1940fd660689d10bf11cb682dd0d6d863"
  end

  resource "swift-markdown" do
    url "https://github.com/apple/swift-markdown/archive/refs/tags/swift-5.6.3-RELEASE.tar.gz"
    sha256 "b46eb86815d9a0b1b4735134c0454c6f89d619f1a9022a7e578b38bbe8b21278"
  end

  resource "swift-cmark-gfm" do
    url "https://github.com/apple/swift-cmark/archive/refs/tags/swift-5.6.3-RELEASE-gfm.tar.gz"
    sha256 "a922cb0d402379528c272dfdc5a7dad24fb96b627fbd23b77371741e619e6962"
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
    url "https://github.com/jpsim/Yams/archive/refs/tags/4.0.2.tar.gz"
    sha256 "8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a"
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

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink tools
        editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib stdlib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
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
        --skip-build-benchmarks
        --jobs=#{ENV.make_jobs}
        --verbose-build

        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --skip-build-benchmarks
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
          --lldb-no-debugserver
          --lldb-use-system-debugserver
        ]
        extra_cmake_options += %W[
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
          -DCMAKE_INSTALL_RPATH=#{loader_path}
        ]

        # Some scripts still reference "python" rather than "python3".
        # Remove this with Swift 5.7.
        python_workaround = workspace/"python-workaround"
        mkdir python_workaround
        ln_s Utils.safe_popen_read("xcrun", "-find", "python3").chomp, python_workaround/"python"
        ENV.prepend_path "PATH", python_workaround
      end
      if OS.linux?
        args += %W[
          --libcxx
          --foundation
          --libdispatch
          --xctest
          --skip-early-swift-driver

          --host-target=linux-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --install-libcxx
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]
        rpaths = [loader_path, rpath, rpath(target: lib/"swift/linux")]
        extra_cmake_options << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(":")}"

        ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin" # Remove with Swift 5.7
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
