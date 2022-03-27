class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/72/b1/2b860383f3568fc168f9e843d367675724f2c67feabc2207da90d7fbe47f/ykdl-1.8.0.tar.gz"
  sha256 "29588ec771d364ed91446a5f7f0dcee914119e7e7c99c6860ac46f0ad9622790"
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
    url "https://files.pythonhosted.org/packages/23/aa/fe3796bc467b8108462854dcc12143c8f083b918028f179f02b1a7c33f79/m3u8-1.0.0.tar.gz"
    sha256 "e9886ff0df35d81fadc522df5ef9b516708b09f8109492f1175720e006b9b8e8"
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
