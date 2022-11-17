class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "3d766dc1856d04a8fb6de9942a6220d754d0fa7eae635d5287e7b1cf794c4f45"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30ef15bfdc14b92683770132d1e5cb30fa88903f6691092387fcecb9c4303fa6"
    sha256 cellar: :any,                 arm64_monterey: "3ee7ecb5bf0e592b34e76984df2291c333b07d76f8de1c67671999dafc1bfe34"
    sha256 cellar: :any,                 arm64_big_sur:  "7cb2e8234ef82f9e99012b68fcd2c56e94c119a718295fd1d8504c0b15600663"
    sha256 cellar: :any,                 ventura:        "5aa697a876187788558268c11f7a365c83afa710fc91fadb917b7157c309fdb2"
    sha256 cellar: :any,                 monterey:       "617b22cc2ca68b96e186e402bb184f7d8b955b64094e06ad62a1899337fa2a13"
    sha256 cellar: :any,                 big_sur:        "2fdcc98f12ad2c472e605b1349c9f44d448a89c15131a29290b62fa6f7f263dc"
    sha256 cellar: :any,                 catalina:       "2b81e91d9b892cb157113df5a4ba3fb32b7cc82a07427a8229458080789b1177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f8013d4754073cd5e70d022bc85b5d39a0fe4ca92c64547d9e5523fa04c234"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "bzip2"

  on_linux do
    depends_on "gnustep-base"
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
