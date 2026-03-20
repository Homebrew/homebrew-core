class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 7
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0ef068932336d86ad68784341497223c5d17d6e56ed564a698d6686031ff97fa"
    sha256 cellar: :any,                 arm64_sequoia: "e38bf30cf01db29aa27d0bf1b208009eb6d64547904f6923ef6994bb74e264c7"
    sha256 cellar: :any,                 arm64_sonoma:  "5114acd866a2552989947614859b3cfd347c52cebc1d7ae4677824e9db94f56b"
    sha256 cellar: :any,                 sonoma:        "0d686d8ad4563aab687d8a48578ccafde6bec7681939c280357ef02f14829f5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85565efda882c47c9abf8d29ad7da951ab88459bf5cabb179a21fecaeb46158c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128ef931a133a2dba46f9bfacfe00d28830ec81adcea315d026159321fd1a79d"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c@78"
    depends_on "libobjc2"
    depends_on "wavpack"
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    cause "GCC Objective-C support is insufficient"
  end

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
      bash_completion.install "unar.bash_completion" => "unar"
      bash_completion.install "lsar.bash_completion" => "lsar"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_path_exists testpath/"README.md"
  end
end
