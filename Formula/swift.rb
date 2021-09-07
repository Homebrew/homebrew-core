class Swift < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "High-performance system programming language"
  homepage "https://swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/swift-5.4.2-RELEASE.tar.gz"
  sha256 "df36ef943e0759b602d36d538e0f19db60a1b56b01f6b8bff2564313f665a183"
  license "Apache-2.0"

  livecheck do
    url "https://swift.org/download/"
    regex(/Releases<.*?>Swift v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f425aed852970268b2b14306094e0227ede33e58d904a9f9a77f629b83c73580"
    sha256 cellar: :any, big_sur:       "90b1107a0cec3fca7669c15f300718e7c830bad52736bc80fe6f9834c552eaa0"
    sha256 cellar: :any, catalina:      "2e106032a395de5a62d8b414ddb2d2fd8818a4f90da57d571fb702b032ba47ee"
    sha256               x86_64_linux:  "7acd57023583fe073ef52ddd35c254f9502d4a5d6e8098269e4e50d8c3313884"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE/docs/HowToGuides/GettingStarted.md#macos
  depends_on xcode: ["12.2", :build]

  depends_on "python@3.9"

  # HACK: this should not be a test dependency but is due to a limitation with fails_with
  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "rsync" => :build
  uses_from_macos "curl"
  uses_from_macos "icu4c"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "six" => :build

    resource "swift-corelibs-foundation" do
      url "https://github.com/apple/swift-corelibs-foundation/archive/swift-5.4.2-RELEASE.tar.gz"
      sha256 "38e15b60188a4240fe71b9ca6e9409d423d342896102ac957db42d7fa8b4ad23"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/swift-5.4.2-RELEASE.tar.gz"
      sha256 "84602423596712a1fd0d866d640af0c2de56c52ea03c95864af900a55945ef37"
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/swift-5.4.2-RELEASE.tar.gz"
      sha256 "5e0bede769b0869e65d2626a3bfdab09faf99dfe48366a37e5c72dc3b7dc9287"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "50401b5b696292ccf6dc11f59f34f8958fdc0097c7d4db9cd862a4622ee1676a"

    # Fix handling of arm64e in REPL mode.
    # Remove with Swift 5.6.
    patch do
      url "https://github.com/apple/llvm-project/commit/479b672ff9a9230dee37fad97413a88bc0ab362b.patch?full_index=1"
      sha256 "6e33121d6f83ecf3bd1307664caf349964d8226530654a3b192b912c959fa671"
    end
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "d1c2d9728667a563e9420c608ef4fcde749a86e38ee373e8b109bce5eb94510d"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "d5562e63fd68f6fcd64c60820a1be0142592a2742c71c1c6fe673f34854ac599"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "3648d7cbf74a2ad69b444d78b53e278541b1bd0e4e54fb1b8bc9002596bbaf4b"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "876f170ecbce1461cc21509a52d11b4e79a045f6348e0d8f1c643e9e6e0e1624"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "2eff815309fa34bcb18a70298e16deb974862806a449c93eb245162030fe4d73"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "9907e6d41236cf543a43a89b5ff67b6cb12474692f96069908d4b6f92b617518"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/swift-5.4.2-RELEASE.tar.gz"
    sha256 "a4bc991cf601fe0f45edc7d0a6248f1a19def4d149b3e86b37361f34b0ecbd2c"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/0.4.1.tar.gz"
    sha256 "6743338612be50a5a32127df0a3dd1c34e695f5071b1213f128e6e2b27c4364a"
  end

  # Similar scenario as above - see the above file to find the version to use here.
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/4.0.2.tar.gz"
    sha256 "8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a"
  end

  # Don't build and install some test binaries.
  # Remove with Swift 5.5.
  patch do
    url "https://github.com/apple/swift/commit/86c40574f594f4f7b4b25bb02cc2389e1328c200.patch?full_index=1"
    sha256 "6d22d159b8c16ec14c4ec1e7ea258ffa489f932842b0f4be930d0f9660cbe9b4"
  end

  # Fix arm64 build not being able to use the arm64e standard library.
  # Based on https://github.com/apple/swift/pull/39083.
  # This patch has been adapted for Swift 5.4
  # and should be updated with Swift 5.5 to more closely match the upstream PR.
  patch :DATA

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    install_prefix =if OS.mac?
      toolchain_prefix = "/Swift-#{version}.xctoolchain"
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
    ]
    inreplace helpers_using_swiftpm, "swiftpm_args = [", "\\0'--disable-sandbox',"

    # Fix finding of brewed sqlite3.h.
    if OS.linux?
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

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink tools
        editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
      ]

      llvm_components << "dsymutil" if OS.mac?
      if OS.linux?
        swift_components += %w[
          stdlib sdk-overlay
          autolink-driver
          sourcekit-inproc
        ]
        llvm_components << "lld"
      end

      pre_args = %W[
        --host-cc=#{which(ENV.cc)}
        --host-cxx=#{which(ENV.cxx)}
        --release --assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --lldb --llbuild --swiftpm --swift-driver
        --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build
      ]
      post_args = %W[
        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --swift-include-tests=0
        --llvm-include-tests=0
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --install-llvm
        --llvm-install-components=#{llvm_components.join(";")}
        --install-lldb
        --install-llbuild
        --install-swiftpm
        --install-swift-driver
        --install-sourcekit-lsp
      ]
      extra_cmake_options = []

      if OS.mac?
        post_args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --lldb-no-debugserver
          --lldb-use-system-debugserver
        ]
        extra_cmake_options += %w[
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
          -DCMAKE_INSTALL_RPATH=@loader_path
        ]
      end
      if OS.linux?
        pre_args += %w[
          --libcxx
          --foundation
          --libdispatch
          --xctest
        ]
        post_args += %W[
          --host-target=linux-#{Hardware::CPU.arch}
          --build-swift-dynamic-stdlib
          --build-swift-dynamic-sdk-overlay
          --build-swift-stdlib-unittest-extra
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --install-libcxx
          --install-foundation
          --install-libdispatch
          --install-xctest
          --swift-cmake-options=-DCMAKE_INSTALL_RPATH=$ORIGIN/../lib:$ORIGIN/../lib/swift/linux
          --xctest-cmake-options=-DCMAKE_INSTALL_RPATH=$ORIGIN
        ]
        extra_cmake_options += %W[
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_UC_INCLUDE=#{Formula["icu4c"].opt_include}
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_UC=#{Formula["icu4c"].opt_lib}/libicuuc.so
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_I18N_INCLUDE=#{Formula["icu4c"].opt_include}
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_I18N=#{Formula["icu4c"].opt_lib}/libicui18n.so
        ]

        ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
      end

      post_args += %W[
        --extra-cmake-options=#{extra_cmake_options.join(" ")}
      ]

      ENV["SKIP_XCODE_VERSION_CHECK"] = "1"
      system "#{workspace}/swift/utils/build-script", *pre_args, "--", *post_args
    end

    if OS.mac?
      # Swift Package Manager binaries bake in the absolute path to the stdlib.
      # Removing them will allow relocatable bottles.
      # Note that the binaries do also already contain the relative path.
      %w[
        bin/swift-build
        bin/swift-package
        bin/swift-run
        bin/swift-test
        libexec/swift/pm/swiftpm-xctest-helper
      ].each do |path|
        binary = "#{prefix}#{install_prefix}/#{path}"
        MachO::Tools.delete_rpath(binary, "#{prefix}#{install_prefix}/lib/swift/macosx")

        next unless Hardware::CPU.arm?

        # Regenerate signature after modification.
        cp binary, "#{binary}-tmp"
        MachO.codesign!("#{binary}-tmp")
        mv "#{binary}-tmp", binary, force: true
      end
    end

    if OS.linux?
      bin.install_symlink Dir["#{libexec}/bin/{swift,sil,sourcekit}*"]
      man1.install_symlink libexec/"share/man/man1/swift.1"
      elisp.install_symlink libexec/"share/emacs/site-lisp/swift-mode.el"
      doc.install_symlink Dir["#{libexec}/share/doc/swift/*"]
    end

    rewrite_shebang detected_python_shebang, *Dir["#{prefix}#{install_prefix}/bin/*.py"]
  end

  def caveats
    on_macos do
      <<~EOS
        The toolchain has been installed to:
          #{opt_prefix}/Swift-#{version}.xctoolchain

        You can find the Swift binary at:
          #{opt_prefix}/Swift-#{version}.xctoolchain/usr/bin/swift

        You can also symlink the toolchain for use within Xcode:
          ln -s #{opt_prefix}/Swift-#{version}.xctoolchain ~/Library/Developer/Toolchains/Swift-#{version}.xctoolchain
      EOS
    end
  end

  test do
    toolchain_prefix = ""
    on_macos do
      toolchain_prefix = "/Swift-#{version}.xctoolchain/usr"
    end

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
    output = shell_output("#{prefix}#{toolchain_prefix}/bin/swift -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'EOS'
      import Foundation

      let swifty = URLComponents(string: "https://swift.org")!
      print("\(swifty.host!)")
    EOS
    output = shell_output("#{prefix}#{toolchain_prefix}/bin/swift -v foundation-test.swift")
    assert_match "swift.org\n", output

    # Test compiler
    system "#{prefix}#{toolchain_prefix}/bin/swiftc", "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test")
    assert_match "swift.org\n", output

    # Test Swift Package Manager
    mkdir "swiftpmtest" do
      on_macos do
        # Swift Package Manager does not currently support using SDKROOT.
        ENV.remove_macosxsdk
      end
      system "#{prefix}#{toolchain_prefix}/bin/swift", "package", "init", "--type=executable", "-v"
      cp "../foundation-test.swift", "Sources/swiftpmtest/main.swift"
      system "#{prefix}#{toolchain_prefix}/bin/swift", "build", "-v", "--disable-sandbox"
      assert_match "swift.org\n", shell_output("#{prefix}#{toolchain_prefix}/bin/swift run --disable-sandbox")
    end
  end
end

__END__
diff --git a/lib/Serialization/SerializedModuleLoader.cpp b/lib/Serialization/SerializedModuleLoader.cpp
index 5ba5de6eeebfc..02b21af921d04 100644
--- a/lib/Serialization/SerializedModuleLoader.cpp
+++ b/lib/Serialization/SerializedModuleLoader.cpp
@@ -46,8 +46,21 @@ namespace {
 void forEachTargetModuleBasename(const ASTContext &Ctx,
                                  llvm::function_ref<void(StringRef)> body) {
   auto normalizedTarget = getTargetSpecificModuleTriple(Ctx.LangOpts.Target);
+
+  // An arm64 module can import an arm64e module.
+  Optional<llvm::Triple> normalizedAltTarget;
+  if (normalizedTarget.getArch() == llvm::Triple::ArchType::aarch64) {
+    auto altTarget = normalizedTarget;
+    altTarget.setArchName("arm64e");
+    normalizedAltTarget = getTargetSpecificModuleTriple(altTarget);
+  }
+
   body(normalizedTarget.str());

+  if (normalizedAltTarget) {
+    body(normalizedAltTarget->str());
+  }
+
   // We used the un-normalized architecture as a target-specific
   // module name. Fall back to that behavior.
   body(Ctx.LangOpts.Target.getArchName());
@@ -61,6 +76,10 @@ void forEachTargetModuleBasename(const ASTContext &Ctx,
   if (Ctx.LangOpts.Target.getArch() == llvm::Triple::ArchType::arm) {
     body("arm");
   }
+
+  if (normalizedAltTarget) {
+    body(normalizedAltTarget->getArchName());
+  }
 }
