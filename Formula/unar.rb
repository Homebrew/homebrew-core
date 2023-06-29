class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "3d766dc1856d04a8fb6de9942a6220d754d0fa7eae635d5287e7b1cf794c4f45"
  license "LGPL-2.1-or-later"
  revision 3
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a62fcd6b7711eb0c3d2cda6533129bee6d9599f8c64ce874055dcd348ba32aa"
    sha256 cellar: :any,                 arm64_monterey: "1fe80e3891fbcac49b17ef990d772921fbdde9307d72eb569f45f65347803739"
    sha256 cellar: :any,                 arm64_big_sur:  "57937eefa10b7059049be3c8fbbc9b66e35b5738176af3568b0f21f13d7c551d"
    sha256 cellar: :any,                 ventura:        "c1c36c867a066ae74a9ba147171eb9bb0830f67e0a036de32825a70133036bf2"
    sha256 cellar: :any,                 monterey:       "c3b4d3aae136b2baf418bd9d93f40d90f3d68b5f7a837704f56efecd57d7683b"
    sha256 cellar: :any,                 big_sur:        "e852dd613c62439aeb347ed58109e5f1a84dc1a18e98cfc410e48db141fc7bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb90d64818e6d27e309cef03344d6f5561c56b30d5eeb927c364307c03688e90"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c"
    depends_on "wavpack"
  end

  # Clang must be used on Linux because GCC Objective C support is insufficient.
  fails_with :gcc

  resource "universal-detector" do
    url "https://github.com/MacPaw/universal-detector/archive/refs/tags/1.1.tar.gz"
    sha256 "8e8532111d0163628eb828a60d67b53133afad3f710b1967e69d3b8eee28a811"
  end

  def install
    resource("universal-detector").stage buildpath/"../UniversalDetector"

    # Link to libc++.dylib instead of libstdc++.6.dylib
    inreplace "XADMaster.xcodeproj/project.pbxproj", "libstdc++.6.dylib", "libc++.1.dylib"

    # Replace usage of __DATE__ to keep builds reproducible
    inreplace %w[lsar.m unar.m], "@__DATE__", "@\"#{time.strftime("%b %d %Y")}\""

    # Makefile.linux does not support an out-of-tree build.
    if OS.mac?
      mkdir "build" do
        # Build XADMaster.framework, unar and lsar
        arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
        %w[XADMaster unar lsar].each do |target|
          xcodebuild "-target", target, "-project", "../XADMaster.xcodeproj",
                     "SYMROOT=#{buildpath/"build"}", "-configuration", "Release",
                     "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}", "ARCHS=#{arch}", "ONLY_ACTIVE_ARCH=YES"
        end

        bin.install "./Release/unar", "./Release/lsar"
        %w[UniversalDetector XADMaster].each do |framework|
          lib.install "./Release/lib#{framework}.a"
          frameworks.install "./Release/#{framework}.framework"
          (include/"lib#{framework}").install_symlink Dir["#{frameworks}/#{framework}.framework/Headers/*"]
        end
      end
    else
      system "make", "-f", "Makefile.linux"
      bin.install "unar", "lsar"
      lib.install buildpath/"../UniversalDetector/libUniversalDetector.a", "libXADMaster.a"
    end

    cd "Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_predicate testpath/"README.md", :exist?
  end
end
