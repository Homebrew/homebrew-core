class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.10.1_src.zip"
  version "1.10.1"
  sha256 "40967014a505b7a27864c49dc3b5d30b98ae4e6d4873783b2ef9ef9215fd092b"

  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  bottle do
    cellar :any
    sha256 "bd712f6dc4a543d4af936e85d0fcceadc32c2a0ca3c7db11bf484515f2ddd8da" => :sierra
    sha256 "90f8103e17eedfa6825268488c425e050e24ad703919e8aa63bfbd4c03fcf44f" => :el_capitan
    sha256 "b337f36dc2ec53be49d52ceee23924670319c819b259e39c76fe57720bfb1659" => :yosemite
    sha256 "dab9604cafaab887741e0d6511f88e7ca66ad556ee86a41f4b1896ec558d9650" => :mavericks
  end

  depends_on :xcode => :build

  def install
    # ZIP for 1.10.1 additionally contains a `__MACOSX` directory, preventing
    # stripping of the first path component during extraction of the archive.
    mv Dir["The Unarchiver/*"], "."

    # Build XADMaster.framework, unar and lsar
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-alltargets", "-configuration", "Release", "clean"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "XADMaster", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "unar", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "lsar", "SYMROOT=../", "-configuration", "Release"

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
    assert (testpath/"README.md").exist?
  end
end
