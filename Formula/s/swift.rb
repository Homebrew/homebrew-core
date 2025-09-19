class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/swiftlang/swift/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
  sha256 "012bd56c8edd2c61df4cddad5d2fd634c045146016570a431cd1a0e0c28a16a9"
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
        url "https://download.swift.org/swift-5.10.1-release/ubuntu2204/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04.tar.gz"
        sha256 "cab1bfffd33b79ebd49f4b7475bef6c7eb2d60cf3948cbc693d61afabd23c282"
      end

      on_arm do
        url "https://download.swift.org/swift-5.10.1-release/ubuntu2204-aarch64/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04-aarch64.tar.gz"
        sha256 "871b00f0a7f96e0d28da53b232181c900a7540cb4be37fe4916c15ab411f83c9"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
      sha256 "871b5b034b0f42b26b9da0f50bea7f7e24f12594fa5b9536c622acb3d942dbe6"
    end

    resource "swift-foundation" do
      url "https://github.com/apple/swift-foundation/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
      sha256 "94a6f5356ad2603c8bb325cafb26476af0d6007712a089d6427441357c9bfaab"
    end

    resource "swift-foundation-icu" do
      url "https://github.com/apple/swift-foundation-icu/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
      sha256 "484b06da71a21730827dec01a8b3565035e4e8dee2b3e1a7b171136a1d74341a"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
      sha256 "d4b8171d6711dabc3cb81093e954cedd521c8e4c170a688c1c369194c9eae4b3"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
      sha256 "e511797ba3202b77f925f9cd8afa7884bc7104e1e509b00663d48dc5185bfc20"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/swiftlang/llvm-project/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "394a5ac36216820031f5ab70d78eeb8cf466d868ce436b20e857282d6408c5bd"
  end

  resource "cmark" do
    url "https://github.com/swiftlang/swift-cmark/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "f5cb03fa6aab841742ff10dfcd4d8422682e8528e28a4cd4e2d18aa87bf0e95c"
  end

  resource "llbuild" do
    url "https://github.com/swiftlang/swift-llbuild/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "d03b967786d710d4206644071ad1c0b006e13ea3ab2a3866601c3feba23f5937"
  end

  resource "swiftpm" do
    url "https://github.com/swiftlang/swift-package-manager/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "ceb1e5c6fc1b4a5e0b69d2897a336c1c57be07202bfc5d8d7b486be82bd78215"
  end

  resource "indexstore-db" do
    url "https://github.com/swiftlang/indexstore-db/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "167c53c0fae33b95a215af0c899623f665911999165cbe1a231d3d161de7d0eb"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/swiftlang/sourcekit-lsp/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "d146994288c4359712a1577120a972b65fa23b543b1a172d93d03322056dc5ee"
  end

  resource "swift-driver" do
    url "https://github.com/swiftlang/swift-driver/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "ffec2b3e20e5a9270d5328fde48ea14d11616514f89a718284c96e239f7ec49c"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/swiftlang/swift-tools-support-core/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "f8b453d6b7223e4026ae545301bc7ea637d73240fa5e2fd22030e8d209b37b6f"

    # Fix "close error" when compiling SwiftPM.
    # https://github.com/swiftlang/swift-tools-support-core/pull/456
    patch do
      url "https://github.com/Bo98/swift-tools-support-core/commit/dca5ee70e302df065178cc8a75a2d6ea00886c40.patch?full_index=1"
      sha256 "e5e2e7cec7b7bd9ef0def5cfc9b1308fe1f25f6228973031c9821b2c4475c8a1"
    end
  end

  resource "swift-docc" do
    url "https://github.com/swiftlang/swift-docc/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "13c74815b7657dc3048c75c364401e776274eb5dbcbd24a04e92f16735b6faee"
  end

  resource "swift-lmdb" do
    url "https://github.com/swiftlang/swift-lmdb/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "89e3d5816775f48c1b19c03fa670b09e1b7582a7df8e68b1f9e7808495f1b0cf"
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/swiftlang/swift-docc-render-artifact/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "fb4719002f09090799558e27122e666db0259a8fc72557aa0f007e44cb1f886b"
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/swiftlang/swift-docc-symbolkit/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "f89c1b576e67be97eaaf2973026a9907f70858a1f90198bbcf634f4d2af3af9a"
  end

  resource "swift-markdown" do
    url "https://github.com/swiftlang/swift-markdown/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "03304f13bb60e4ba78a83d98c4843094b26271e6e88a10feab7b2d0aa44a9910"
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/swiftlang/swift-experimental-string-processing/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "40027a11963771722a2539f538bdcc265c209cae7a9fd93d8f0a71f13e338b0d"
  end

  resource "swift-syntax" do
    url "https://github.com/swiftlang/swift-syntax/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "482066ea299fdc05c9eb74886724a941d6ef09e84c6e75cc6ae7bb0040e768f2"
  end

  resource "swift-testing" do
    url "https://github.com/swiftlang/swift-testing/archive/refs/tags/swift-6.2-RELEASE.tar.gz"
    sha256 "0de80cc99b6938b8427ec9b4c1bef661c414db03ab29b30611cf28381705c832"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/swiftlang/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.6.1.tar.gz"
    sha256 "d2fbb15886115bb2d9bfb63d4c1ddd4080cbb4bfef2651335c5d3b9dd5f3c8ba"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-atomics" do
    url "https://github.com/apple/swift-atomics/archive/refs/tags/1.3.0.tar.gz"
    sha256 "556761d16bae75278bb2c64d8ab510b98d133d0809ca06a2ba32fac96fae916e"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-collections" do
    url "https://github.com/apple/swift-collections/archive/refs/tags/1.2.1.tar.gz"
    sha256 "7474a23b80a4a86349c747900f6feab8a20be93faa9127e2a09bfa81b831a4b7"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https://github.com/apple/swift-crypto/archive/refs/tags/3.15.0.tar.gz"
    sha256 "2a81fa9e9b15cab3b215abe86cbe0ab49cea32ba6353200091b9a1ab6fd0dbb8"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-certificates" do
    url "https://github.com/apple/swift-certificates/archive/refs/tags/1.14.0.tar.gz"
    sha256 "123859cea6ab8b1d77407037bd4c2e77ad89eab4e2a0b177e0482717346c4867"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-asn1" do
    url "https://github.com/apple/swift-asn1/archive/refs/tags/1.4.0.tar.gz"
    sha256 "a08cbe06e06964e29c6d50ee58de05f3492073805ab9f6cc712ef99fb2b50232"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-numerics" do
    url "https://github.com/apple/swift-numerics/archive/refs/tags/1.1.0.tar.gz"
    sha256 "1a94f33001202bcf13dc1d8a7acf8691b81c165f6893ba6679cba5744f24341d"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-system" do
    url "https://github.com/apple/swift-system/archive/refs/tags/1.6.3.tar.gz"
    sha256 "09039b8a7ff98319d329f8de3c9dadf76f47fc35066bc520776ea16e0576dfbc"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/refs/tags/6.1.0.tar.gz"
    sha256 "9561244f85187e19a497e475741fa6dba0d33fb04e43c3f517718551c40c9efb"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https://github.com/apple/swift-nio/archive/refs/tags/2.86.0.tar.gz"
    sha256 "8d179c28ac19a4657ee45b81c30bbb92b47dc18d9d4d151c6bb3f162e64c8ccf"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio-ssl" do
    url "https://github.com/apple/swift-nio-ssl/archive/refs/tags/2.34.0.tar.gz"
    sha256 "bb301de32901f2ca82bff0ef8180d28e671f0f5b39314c8207fdfcb1dacfe405"
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
      workspace/"swift-docc/build-script-helper.py",
    ]
    inreplace helpers_using_swiftpm, "swiftpm_args = [", "\\0'--disable-sandbox',"
    inreplace workspace/"sourcekit-lsp/Utilities/build-script-helper.py",
              "swiftpm_args: List[str] = [",
              "\\0'--disable-sandbox',"
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
      inreplace workspace/"swift-corelibs-foundation/CMakeLists.txt",
                '"$ORIGIN"',
                "\"$ORIGIN:#{ENV["HOMEBREW_RPATH_PATHS"]}\""
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
