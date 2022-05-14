class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/94/0c/723886d89167fa7ab4fa8847c646da95ef6cf56afadf7098619d4223fb62/ykdl-1.8.1.tar.gz"
  sha256 "28b6415c03efd6141034c8d46c0483d27276bcd7d189fd12e48dd5762f79a868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3505a806ade983e0f51e361b436e084a2b63efba6b3fa245465eee7025126daa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "980647710cc5dcd8a7cc434ba431bcab6771c2d8e180f0724147c0ce30df2340"
    sha256 cellar: :any_skip_relocation, monterey:       "83fa9f7ae1f8330b895d92f6a58375557558b6d4531398c662101609126d88e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bff00bf48e76078d2d64ae55c730e2c0d4d5d4785436c9233fe1ba9f8764328d"
    sha256 cellar: :any_skip_relocation, catalina:       "e505527a15ef8eb67df22cd6edfd6c113d7d51475f98d29e03a284ccf2b36148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe84e64f4690d6ede807ea533b9b4a145f9cfbeea74b26160535360f2e52454"
  end

  depends_on "python@3.10"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/28/97/d2d3d96952c77e7593e0f4a634656fb384f7282327f7fef74b726b3b4c1c/iso8601-1.0.2.tar.gz"
    sha256 "27f503220e6845d9db954fb212b95b0362d8b7e6c1b2326a87061c3de93594b1"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/1c/1c/899994765c0395caec18b3e5381e61bac256c35a43f80fb468f3de689f95/jsengine-1.0.5.tar.gz"
    sha256 "f9676bad44904483f0b17bf2838b07893c9fbaf575f2153e46735b767243199f"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/0a/c1/ea98c5f109be04a745d01437f77b801192f3cf56cb834fa5e660f0a0ce03/m3u8-2.0.0.tar.gz"
    sha256 "bd8727a74c23fd706f2dc2a53f319391589ea64bb3a5c76b1c9b5707d8f4a0b0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAzNDM5NTQ5Mg==.html"
  end
end
