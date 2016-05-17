class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.10_src.zip"
  version "1.10"
  sha256 "866320ef9a4a21d593d314e229e38d928bbb31965b9e81ed347bfbf55fc2f25f"

  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  bottle do
    cellar :any
    sha256 "3f0abeedfdc17860ef6f8f8406b34cc6fb2b334e13c3081d00fb7c2ef98f7cc1" => :el_capitan
    sha256 "829f81a91ebb65385bb5b39944f40a8a6a3a900e4717ef00cf608fec2884e3d6" => :yosemite
  end

  depends_on :xcode => :build

  def install
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
