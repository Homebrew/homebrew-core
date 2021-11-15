class Swift < Formula
  include Language::Python::Shebang

  desc "High-performance system programming language"
  homepage "https://swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/swift-5.5.1-RELEASE.tar.gz"
  sha256 "b4092b2584919f718a55ad0ed460fbc48e84ec979a9397ce0adce307aba41ac9"
  license "Apache-2.0"

  livecheck do
    url "https://swift.org/download/"
    regex(/Releases<.*?>Swift v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "803ea73f224d38aedf294dcd0096fb358cf21fad4633a3f47a275e0dd53a4e44"
    sha256 cellar: :any,                 arm64_big_sur:  "f7edacc38c4468f861618eceea75f446f2cc75079d7ff73a3bc43ffd2608f895"
    sha256 cellar: :any,                 monterey:       "b567de7928d285220accb588371311b59f7e34afffeaa0b9ff5c84cfab11e73a"
    sha256 cellar: :any,                 big_sur:        "6dfbf15ff07819809c517c6bf100de4b5420a2b37598a7f1dee15d77fd326ad4"
    sha256 cellar: :any,                 catalina:       "bfa10d795640b722db43c6cf261930844df82ba265712039478d00687254e0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a5b18d199ff1df49f3f00ad64070f8d6b16b37e83989174d9e7755fb3217b2"
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE/docs/HowToGuides/GettingStarted.md#macos
  depends_on xcode: ["12.3", :build]

  depends_on "python@3.10"

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
      url "https://github.com/apple/swift-corelibs-foundation/archive/swift-5.5.1-RELEASE.tar.gz"
      sha256 "ab99fbcf0e8ede00482c614cfd0c4c42a27ae94744ca3ce0d9b03a52a3f8d4d0"
    end

    resource "swift-corelibs-libdispatch" do
      url "https://github.com/apple/swift-corelibs-libdispatch/archive/swift-5.5.1-RELEASE.tar.gz"
      sha256 "de280f470850d98887eeb0f2b4dc3524d0f2f8eb93af5618d4f1e5312d4cbbdf"

      # Fix unused refcount error.
      # Remove with Swift 5.6.
      patch do
        url "https://github.com/apple/swift-corelibs-libdispatch/commit/729e25d92d05a8c4a8136e831ec6123bbf7f2654.patch?full_index=1"
        sha256 "1998de1a9a422036eab8c2694ee6cd480f86a873ecbef0241b0893c3e3387c8b"
      end
    end

    resource "swift-corelibs-xctest" do
      url "https://github.com/apple/swift-corelibs-xctest/archive/swift-5.5.1-RELEASE.tar.gz"
      sha256 "11ee237c61dcd1fb20b30c35a552e5c0044d069cbaad9fb9bddd175efec4f984"
    end
  end

  # Currently requires Clang to build successfully.
  fails_with :gcc

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "095763d76000b95910ce19837d45b932a48f8ab4a002a8b27e986b1a29e8432f"

    # Fix handling of arm64e in REPL mode.
    # Remove with Swift 5.6.
    patch do
      url "https://github.com/apple/llvm-project/commit/479b672ff9a9230dee37fad97413a88bc0ab362b.patch?full_index=1"
      sha256 "6e33121d6f83ecf3bd1307664caf349964d8226530654a3b192b912c959fa671"
    end

    # Fix some invisible characters on Linux in REPL mode.
    # Remove with Swift 5.6.
    patch do
      url "https://github.com/apple/llvm-project/commit/075de2d8a7567a6a39e8477407960aa2545b68c2.patch?full_index=1"
      sha256 "4a3372b06eace476349619532ce57d028315190dec83a2de521efdee22067952"
    end
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "36c9de0d5a7f71455542c780b8a0a4bd703e6f0d1456a5a1a9caf22e3cb4182a"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "39998792dea9d36ec1b98d07e9e6100a9853e9a3f845b319de81cf1aaae6a8dd"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "73331ad0d27f1e40a0d50d45337f986e0303dd0c872a0991db916126bd3949fe"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "a678003f61b2795ee76d89fd4f008a77fab4522d275764db413ecce8b0aa66e2"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "9c5f3358e854cf42af1a03567e02d04476bb5b47c3b914512f29ecc46117e445"
  end

  resource "swift-driver" do
    url "https://github.com/apple/swift-driver/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "f8ea378f1d9466fbd0206796dabb03e178390f3fd6584e582038ae75fd75fece"
  end

  resource "swift-tools-support-core" do
    url "https://github.com/apple/swift-tools-support-core/archive/swift-5.5.1-RELEASE.tar.gz"
    sha256 "a2f21a2814286ee23766ae55eebe5a4797ad04fd674ef37a9411a9bd40782222"
  end

  # To find the version to use, check the release/#{version.major_minor} entry of:
  # https://github.com/apple/swift/blob/swift-#{version}-RELEASE/utils/update_checkout/update-checkout-config.json
  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/0.4.3.tar.gz"
    sha256 "9dfcb236f599e309e49af145610957648f8a59d9527b4202bc5bdda0068556d7"
  end

  # As above: refer to update-checkout-config.json
  resource "yams" do
    url "https://github.com/jpsim/Yams/archive/4.0.2.tar.gz"
    sha256 "8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a"
  end

  # As above: refer to update-checkout-config.json
  resource "swift-crypto" do
    url "https://github.com/apple/swift-crypto/archive/1.1.5.tar.gz"
    sha256 "86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f"
  end

  # Homebrew-specific patch to make the default resource directory use opt rather than Cellar.
  # This fixes output binaries from `swiftc` having a runpath pointing to the Cellar.
  # This should only be removed if an alternative solution is implemented.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5e4d9bb4d04c7c9004e95fecba362a843dc00bdd/swift/homebrew-resource-dir.diff"
    sha256 "5210ca0fd95b960d596c058f5ac76412a6987d2badf5394856bb9e31d3c68833"
  end

  # Fix shim and Clang headers not being copied when stdlib isn't built.
  # https://github.com/apple/swift/pull/39405
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/939cc44b01a7f4c0c0ae1c9f037867de38ef5239/swift/5.5-copy_shim_headers.diff"
    sha256 "0e2c2dc96895931e4444f90533cb2b8e1b04c2591f9a2c0492145661efab1760"
  end

  # Fix libdispatch building with tests enabled.
  # https://github.com/apple/swift/pull/39970
  patch do
    url "https://github.com/apple/swift/commit/6be2b40fdd831e6a77baa789820df31e6d2dc6bd.patch?full_index=1"
    sha256 "9203072ae9cdcc07ec1fa2821d9caebb295d816ecb62253447a076dc685e7a6a"
  end

  # Fix arm64 build not being able to use the arm64e standard library.
  # https://github.com/apple/swift/pull/39083
  # https://github.com/apple/swift/pull/39315
  # Remove with Swift 5.6.
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

      llvm_components << "dsymutil" if OS.mac?
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
        --indexstore-db --sourcekit-lsp
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
        --install-sourcekit-lsp
      ]
      extra_cmake_options = []

      if OS.mac?
        args += %W[
          --host-target=macosx-#{Hardware::CPU.arch}
          --build-swift-dynamic-stdlib=0
          --build-swift-dynamic-sdk-overlay=0
          --stdlib-deployment-targets=
          --swift-darwin-supported-archs=#{Hardware::CPU.arch}
          --swift-darwin-module-archs=#{Hardware::CPU.arch}
          --lldb-no-debugserver
          --lldb-use-system-debugserver
        ]
        extra_cmake_options += %w[
          -DLLDB_FRAMEWORK_COPY_SWIFT_RESOURCES=0
          -DCMAKE_INSTALL_RPATH=@loader_path
        ]
        # Needed until back-deploy concurrency lands.
        extra_cmake_options << "-DSWIFT_IMPLICIT_CONCURRENCY_IMPORT=OFF" if MacOS.version < :monterey
      end
      if OS.linux?
        args += %W[
          --libcxx
          --foundation
          --libdispatch
          --xctest

          --host-target=linux-#{Hardware::CPU.arch}
          --stdlib-deployment-targets=linux-#{Hardware::CPU.arch}
          --install-libcxx
          --install-foundation
          --install-libdispatch
          --install-xctest
        ]
        extra_cmake_options += %W[
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_UC_INCLUDE=#{Formula["icu4c"].opt_include}
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_UC=#{Formula["icu4c"].opt_lib}/libicuuc.so
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_I18N_INCLUDE=#{Formula["icu4c"].opt_include}
          -DSWIFT_LINUX_#{Hardware::CPU.arch}_ICU_I18N=#{Formula["icu4c"].opt_lib}/libicui18n.so
          -DCMAKE_INSTALL_RPATH=$ORIGIN:$ORIGIN/../lib:$ORIGIN/../lib/swift/linux
        ]

        ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
      end

      args << "--extra-cmake-options=#{extra_cmake_options.join(" ")}"

      ENV["SKIP_XCODE_VERSION_CHECK"] = "1"
      system "#{workspace}/swift/utils/build-script", *args
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
    output = shell_output("#{bin}/swift -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output

    # Test accessing Foundation
    (testpath/"foundation-test.swift").write <<~'EOS'
      import Foundation

      let swifty = URLComponents(string: "https://swift.org")!
      print("\(swifty.host!)")
    EOS
    output = shell_output("#{bin}/swift -v foundation-test.swift")
    assert_match "swift.org\n", output

    # Test compiler
    system "#{bin}/swiftc", "-v", "foundation-test.swift", "-o", "foundation-test"
    output = shell_output("./foundation-test")
    assert_match "swift.org\n", output

    # Test Swift Package Manager
    mkdir "swiftpmtest" do
      on_macos do
        # Swift Package Manager does not currently support using SDKROOT.
        ENV.remove_macosxsdk
      end
      system "#{bin}/swift", "package", "init", "--type=executable", "-v"
      cp "../foundation-test.swift", "Sources/swiftpmtest/main.swift"
      system "#{bin}/swift", "build", "-v", "--disable-sandbox"
      assert_match "swift.org\n", shell_output("#{bin}/swift run --disable-sandbox")
    end

    # Make sure the default resource directory is not using a Cellar path
    default_resource_dir = JSON.parse(shell_output("#{bin}/swift -print-target-info"))["paths"]["runtimeResourcePath"]
    expected_resource_dir = if OS.mac?
      (opt_prefix/"Swift-#{version.major_minor}.xctoolchain/usr/lib/swift").to_s
    else
      (opt_libexec/"lib/swift").to_s
    end
    assert_equal expected_resource_dir, default_resource_dir
  end
end

__END__
diff --git a/lib/Serialization/SerializedModuleLoader.cpp b/lib/Serialization/SerializedModuleLoader.cpp
index 5ba5de6eeebfc..02b21af921d04 100644
--- a/lib/Serialization/SerializedModuleLoader.cpp
+++ b/lib/Serialization/SerializedModuleLoader.cpp
@@ -46,8 +46,23 @@ namespace {
 void forEachTargetModuleBasename(const ASTContext &Ctx,
                                  llvm::function_ref<void(StringRef)> body) {
   auto normalizedTarget = getTargetSpecificModuleTriple(Ctx.LangOpts.Target);
+
+  // An arm64 module can import an arm64e module.
+  Optional<llvm::Triple> normalizedAltTarget;
+  if ((normalizedTarget.getArch() == llvm::Triple::ArchType::aarch64) &&
+      (normalizedTarget.getSubArch() !=
+       llvm::Triple::SubArchType::AArch64SubArch_arm64e)) {
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
 
 enum class SearchPathKind {
diff --git a/lib/Frontend/ModuleInterfaceLoader.cpp b/lib/Frontend/ModuleInterfaceLoader.cpp
index 85156db2d9ded..537db48daa6e0 100644
--- a/lib/Frontend/ModuleInterfaceLoader.cpp
+++ b/lib/Frontend/ModuleInterfaceLoader.cpp
@@ -1604,6 +1604,10 @@ InterfaceSubContextDelegateImpl::runInSubCompilerInstance(StringRef moduleName,
   // arguments in the textual interface file. So copy to use a new compiler
   // invocation.
   CompilerInvocation subInvocation = genericSubInvocation;
+
+  // Save the target triple from the original context.
+  llvm::Triple originalTargetTriple(subInvocation.getLangOptions().Target);
+
   std::vector<StringRef> BuildArgs(GenericArgs.begin(), GenericArgs.end());
   assert(BuildArgs.size() == GenericArgs.size());
   // Configure inputs
@@ -1653,6 +1657,22 @@ InterfaceSubContextDelegateImpl::runInSubCompilerInstance(StringRef moduleName,
   if (subInvocation.parseArgs(SubArgs, *Diags)) {
     return std::make_error_code(std::errc::not_supported);
   }
+
+  // If the target triple parsed from the Swift interface file differs
+  // only in subarchitecture from the original target triple, then
+  // we have loaded a Swift interface from a different-but-compatible
+  // architecture slice. Use the original subarchitecture.
+  llvm::Triple parsedTargetTriple(subInvocation.getTargetTriple());
+  if (parsedTargetTriple.getSubArch() != originalTargetTriple.getSubArch() &&
+      parsedTargetTriple.getArch() == originalTargetTriple.getArch() &&
+      parsedTargetTriple.getVendor() == originalTargetTriple.getVendor() &&
+      parsedTargetTriple.getOS() == originalTargetTriple.getOS() &&
+      parsedTargetTriple.getEnvironment()
+        == originalTargetTriple.getEnvironment()) {
+    parsedTargetTriple.setArchName(originalTargetTriple.getArchName());
+    subInvocation.setTargetTriple(parsedTargetTriple.str());
+  }
+
   CompilerInstance subInstance;
   SubCompilerInstanceInfo info;
   info.Instance = &subInstance;
