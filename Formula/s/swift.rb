class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://www.swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/swiftlang/swift/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
  sha256 "39825af3b1ab523ed4970e1315a14b5379fb5f8046170c27a330a179d982fe2a"
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
    sha256 cellar: :any, arm64_tahoe:   "aa51dc49e0f8b1433a647ad37b53b1326def6fb4ced8cdedb46aeb46be473f1e"
    sha256 cellar: :any, arm64_sequoia: "a0a63ef471a860d1ef831cb98804671ab6275af773dfe0fc024f7970b6cd2963"
    sha256 cellar: :any, arm64_sonoma:  "a5717a03c5f3a97c1a2b2ac6aa5a106b33e6af79e22d8cbae81f057910fd5d78"
    sha256 cellar: :any, sonoma:        "560fc5a6682c90ef551f4303560dcc8e6831427085becdd86e885af12408a216"
    sha256               arm64_linux:   "df54abb17244ca9d016f6c97c662d9ba5eab2def67d45170f30f2a1b289ec959"
    sha256               x86_64_linux:  "096e007455177fe2f02600c4a6f8a6bcc0ac9e42655932e0f90b127b0d089ba9"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # As a starting point, check `minimum_version` in `validate_xcode_compatibility`:
  # https://github.com/swiftlang/swift/tree/swift-#{version}-RELEASE/utils/build-script
  # This is community-sourced so may not be accurate. If the version in this formula
  # is higher then that is likely why.
  depends_on xcode: ["14.3", :build]

  depends_on "python@3.14"

  uses_from_macos "llvm" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "lld" => :build
    depends_on "python-setuptools" => :build # for distutils in lldb build
    depends_on "util-linux"
    depends_on "zstd" # implicit via curl; not important but might as well

    # Doesn't have to be in sync but does need to be no older than X.(Y - 1).0
    resource "bootstrap" do
      on_arm do
        url "https://download.swift.org/swift-6.1.3-release/ubuntu2204-aarch64/swift-6.1.3-RELEASE/swift-6.1.3-RELEASE-ubuntu22.04-aarch64.tar.gz"
        sha256 "52818b192d59a8d1949336895c38b75a5e35e86e88d384076e8d32398c9c68d1"
      end
      on_intel do
        url "https://download.swift.org/swift-6.1.3-release/ubuntu2204/swift-6.1.3-RELEASE/swift-6.1.3-RELEASE-ubuntu22.04.tar.gz"
        sha256 "28e4b24adf9b1b782b75919d9f2a0b0ad7e16e843aaa203e0baca780248dcdd6"
      end
    end

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
      sha256 "c395a3ca39291bda0f03946c2c4b5730ed02d629a3539adaf90184300228ea72"

      livecheck do
        formula :parent
      end
    end

    resource "swift-foundation" do
      url "https://github.com/apple/swift-foundation/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
      sha256 "411b967971eaa6c6ab4a1ba84fd145c17f4cb053515277bb903f18bf0183edb0"

      livecheck do
        formula :parent
      end
    end

    resource "swift-foundation-icu" do
      url "https://github.com/apple/swift-foundation-icu/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
      sha256 "6e8ce5b8491821e840ea720b795264b5dcc98ad38ea122bc016593ac2be1f520"

      livecheck do
        formula :parent
      end
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
      sha256 "18c6d5945e6668c1928deb72f524dfa26ad9d1b226c7d618cdf766885ccc433c"

      livecheck do
        formula :parent
      end
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
      sha256 "b0d7922af89146ab5a12d9744e965ca3bf587c9bbda2f435ab56a6dad86004a5"

      livecheck do
        formula :parent
      end
    end
  end

  fails_with :gcc do
    cause "Currently requires Clang to build successfully."
  end

  resource "llvm-project" do
    url "https://github.com/swiftlang/llvm-project/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "c0bd5b4bc69dceda1dda5aabee6f24e42e87ec2ccb0ee5f002448ab3c4769fdf"

    livecheck do
      formula :parent
    end
  end

  resource "cmark" do
    url "https://github.com/swiftlang/swift-cmark/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "4f54c388f9a98527cf751ffedb35898c2198b4f23cf16d109203f9ba54a62379"

    livecheck do
      formula :parent
    end
  end

  resource "llbuild" do
    url "https://github.com/swiftlang/swift-llbuild/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "fdc26af47b53779776f1294f674886c774636ef0b0b1b2c2ed90f9626bd018ed"

    livecheck do
      formula :parent
    end

    # Fix build when curses can't be found in the default linker path
    patch do
      url "https://github.com/Bo98/swift-llbuild/commit/61810b86c1c59283edbf1cf7a27f538e1d060537.patch?full_index=1"
      sha256 "e55fe1b2d1e1edd196e2a1a4183454739cfdb4a41cae67ac3cbce6ee15117323"
    end

    # Workaround Homebrew sqlite3 not being found.
    # https://github.com/swiftlang/swift-llbuild/issues/901
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/swift/llbuild-sqlite3.patch"
      sha256 "184ce34784c532ec72d71673218fedb72dc09fdff13fd94c2331e1696d329def"
    end
  end

  resource "swift-build" do
    url "https://github.com/swiftlang/swift-build/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "6284de0771da435c99af96aa1109029ffa47c18a3fb507d1c3266c42e9e7b0f1"

    livecheck do
      formula :parent
    end
  end

  resource "swiftpm" do
    url "https://github.com/swiftlang/swift-package-manager/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "b8f9d96ec4095e46d021dce896d47991ab30d7a487511054a9e630aff4303e42"

    livecheck do
      formula :parent
    end

    # Fix for lld to find -lsqlite3 when auto-linking is done via CMake
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/swift/swiftpm-sqlite3.patch"
      sha256 "78a13abd5a301a3172c3c72ad19a5f1bcfd6c7f142ee90b9417124923dbdd6d1"
    end
  end

  resource "indexstore-db" do
    url "https://github.com/swiftlang/indexstore-db/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "d13695451dfdbb5719527ec66f588da1f5b350553c231655d5dc1e4e84105cec"

    livecheck do
      formula :parent
    end
  end

  resource "sourcekit-lsp" do
    url "https://github.com/swiftlang/sourcekit-lsp/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "0ff9f6f2547b6585512193ee6d87980bc45b71051e19a74d3f09ba257b8123fe"

    livecheck do
      formula :parent
    end
  end

  resource "swift-driver" do
    url "https://github.com/swiftlang/swift-driver/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "004db94c753b437c7ec8260a27f0b79509389503e661dacd244547fdfa1edc23"

    livecheck do
      formula :parent
    end
  end

  resource "swift-tools-support-core" do
    url "https://github.com/swiftlang/swift-tools-support-core/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "a1783534192eaef6de498c10ac02fab70aa64cbc9750252b30ff856046962530"

    livecheck do
      formula :parent
    end

    # Fix "close error" when compiling SwiftPM.
    # https://github.com/swiftlang/swift-tools-support-core/pull/456
    patch do
      url "https://github.com/Bo98/swift-tools-support-core/commit/dca5ee70e302df065178cc8a75a2d6ea00886c40.patch?full_index=1"
      sha256 "e5e2e7cec7b7bd9ef0def5cfc9b1308fe1f25f6228973031c9821b2c4475c8a1"
    end
  end

  resource "swift-docc" do
    url "https://github.com/swiftlang/swift-docc/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "954dcba69da56c63e1636f0dece60d4c8c1250e6bc2b97e20f72e50b068fdd1d"

    livecheck do
      formula :parent
    end
  end

  resource "swift-lmdb" do
    url "https://github.com/swiftlang/swift-lmdb/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "0e60fb6e3ff82253c529f1e0e902f556e8749c963ceb4db8305d2af152da465e"

    livecheck do
      formula :parent
    end
  end

  resource "swift-docc-render-artifact" do
    url "https://github.com/swiftlang/swift-docc-render-artifact/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "7a375a2940bcbb2889bbfab287a32791cc6b32e92e648fc7cc2aac5a5cabb788"

    livecheck do
      formula :parent
    end
  end

  resource "swift-docc-symbolkit" do
    url "https://github.com/swiftlang/swift-docc-symbolkit/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "47e9b732a3e03a803e962333f6934d2648e6685f17328dad7c56874047366b1d"

    livecheck do
      formula :parent
    end
  end

  resource "swift-markdown" do
    url "https://github.com/swiftlang/swift-markdown/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "2cdb1751c22a22eb16b92cd12bb7c7d27d7af103173df1893c2c813dc2098a9e"

    livecheck do
      formula :parent
    end
  end

  resource "swift-experimental-string-processing" do
    url "https://github.com/swiftlang/swift-experimental-string-processing/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "a0055310ebc885ba4781edbcc9aaf44f7ae0cdbc633846bc0a9a6b3f53b29029"

    livecheck do
      formula :parent
    end
  end

  resource "swift-syntax" do
    url "https://github.com/swiftlang/swift-syntax/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "c407424ca6da371425fbbe2a3f097f9df25118764a45b4a3af5e6d0ca4abc14a"

    livecheck do
      formula :parent
    end
  end

  resource "swift-testing" do
    url "https://github.com/swiftlang/swift-testing/archive/refs/tags/swift-6.2.1-RELEASE.tar.gz"
    sha256 "871e4eb07c1467dcac331f2bfa591cbd0a46dc2fee953f67f9b1402941fbd681"

    livecheck do
      formula :parent
    end
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/swiftlang/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
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
    url "https://github.com/apple/swift-system/archive/refs/tags/1.5.0.tar.gz"
    sha256 "4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-nio" do
    url "https://github.com/apple/swift-nio/archive/refs/tags/2.65.0.tar.gz"
    sha256 "feb16b6d0e6d010be14c6732d7b02ddbbdc15a22e3912903f08ef5d73928f90d"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-toolchain-sqlite" do
    url "https://github.com/swiftlang/swift-toolchain-sqlite/archive/refs/tags/1.0.1.tar.gz"
    sha256 "c8704e70c4847a8dbd47aafb25d293fbe1e1bafade16cfa64e04f751e33db0ca"
  end

  # Homebrew-specific patch to make the default resource directory use opt rather than Cellar.
  # This fixes output binaries from `swiftc` having a runpath pointing to the Cellar.
  # This should only be removed if an alternative solution is implemented.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/swift/homebrew-resource-dir.diff"
    sha256 "5210ca0fd95b960d596c058f5ac76412a6987d2badf5394856bb9e31d3c68833"
  end

  # Fix linkage test failure on Linux for missing libswiftCore.so as RPATH was not updated for
  # https://github.com/swiftlang/swift/commit/7f67eb3fc57b95c023f4c7d767a0f241e0ee541a
  patch :DATA

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
    inreplace helpers_using_swiftpm, /swiftpm_args(: List\[str\])? = \[/, "\\0'--disable-sandbox',"
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
        license sourcekit-inproc sourcekit-xpc-service
        swift-remote-mirror swift-remote-mirror-headers stdlib
        static-mirror-lib
      ]
      llvm_components = %w[
        llvm-ar llvm-ranlib llvm-cov llvm-profdata
        llvm-symbolizer IndexStore
        clang clang-resource-headers compiler-rt
        clangd clang-features-file libclang lld
      ]

      if OS.mac?
        swift_components << "back-deployment"
        llvm_components << "dsymutil"
      end
      swift_components << "sdk-overlay" if OS.linux?

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
        --lldb-extra-cmake-args=-DPython3_EXECUTABLE=#{which("python3.14")}
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
        extra_cmake_options << "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"

        ENV.prepend_path "PATH", workspace/"bootstrap/usr/bin"

        # Use lld as Ubuntu 22.04 gold failed with "undefined symbol: _swift_registerConcurrencyRuntime".
        # We no longer include gold in `binutils` while bfd is less tested upstream and increases build time.
        ENV.prepend_path "PATH", Formula["lld"].opt_bin
        args << "--use-linker=lld"
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

      # Remove `swift-backtrace` on macOS without system /usr/lib/swift/libswiftRuntime.dylib
      rm "#{prefix}#{install_prefix}/libexec/swift/macosx/swift-backtrace" if MacOS.version < :tahoe
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
      cp "../foundation-test.swift", "Sources/swiftpmtest/swiftpmtest.swift"
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

__END__
diff --git a/lib/Tooling/libSwiftScan/CMakeLists.txt b/lib/Tooling/libSwiftScan/CMakeLists.txt
index cd68ea874a6..fff338411f4 100644
--- a/lib/Tooling/libSwiftScan/CMakeLists.txt
+++ b/lib/Tooling/libSwiftScan/CMakeLists.txt
@@ -42,6 +42,10 @@ if(SWIFT_HOST_VARIANT_SDK MATCHES "LINUX|ANDROID|OPENBSD|FREEBSD" AND BOOTSTRAPP
     TARGET libSwiftScan
     APPEND PROPERTY INSTALL_RPATH "$ORIGIN/../${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_LIB_SUBDIR}"
   )
+  set_property(
+    TARGET libSwiftScan
+    APPEND PROPERTY INSTALL_RPATH "$ORIGIN/../../${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_LIB_SUBDIR}"
+  )
 endif()

 if(SWIFT_BUILD_SWIFT_SYNTAX)
