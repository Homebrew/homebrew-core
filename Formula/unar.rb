class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.10.1_src.zip"
  sha256 "40967014a505b7a27864c49dc3b5d30b98ae4e6d4873783b2ef9ef9215fd092b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://wakaba.c3.cx/releases/TheUnarchiver/"
    regex(/unarv?(\d+(?:\.\d+)+)_src/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "366fc5e1d3587148e089214a91cd23a96eae1b0aefebcd2e9813b1cc2f6593c2" => :catalina
    sha256 "7bc711ae9affa86d2bc6b29df427dbc900afa6f18bcf13dc4fcf0518f0a50ffa" => :mojave
    sha256 "311cdc91d8897b3ebe20ea6b9e62bb2e4bc4bc15c9d2f321567cd010031df78a" => :high_sierra
  end

  depends_on xcode: :build

  # Fix build for Xcode 10 but remove libstdc++.6.dylib and linking libc++.dylib instead
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a94f6f/unar/xcode10.diff"
    sha256 "d4ac4abe6f6bcc2175efab6be615432b5a8093f8bfc99fba21552bc820b29703"
  end

  def install
    # ZIP for 1.10.1 additionally contains a `__MACOSX` directory, preventing
    # stripping of the first path component during extraction of the archive
    mv Dir["The Unarchiver/*"], "."

    # Build XADMaster.framework, unar and lsar
    %w[XADMaster unar lsar].each do |target|
      xcodebuild "-target", target, "-project", "./XADMaster/XADMaster.xcodeproj", "SYMROOT=..",
                 "-configuration", "Release", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    end

    bin.install "./Release/unar", "./Release/lsar"
    lib.install "./Release/libXADMaster.a"
    frameworks.install "./Release/XADMaster.framework"
    (include/"libXADMaster").install_symlink Dir["#{frameworks}/XADMaster.framework/Headers/*"]

    cd "./Extra" do
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
