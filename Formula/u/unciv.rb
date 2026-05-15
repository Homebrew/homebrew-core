class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/4.20.6/Unciv.jar"
  sha256 "6b7e588d7ef218143957ffbe1eb1fd5e974cef787ecdc27a30a71319a284b2f3"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49176a9651e9afca8ad763d3d52350be7ba114b8555af0d5e56d1b75cf94abde"
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end
