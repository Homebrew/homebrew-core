class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/1e/a2/8d68c0f5bfda82033fac0d36875c185241de37e1ac56f8b3f161e825a1e6/ykdl-1.8.1.post1.tar.gz"
  sha256 "97b179ef7059685fbbb24d4f50ae6e5e01f08e9c0998b292dc1ca44c1af09dc1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640bc5ee77d8ea688159fa49036e16598af7daa688b4c4273ad8af4c0073784b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3925aefb6ab1b1aaaed0017b58389fda5d41caa3576b5abd6d3f90c7b6ad032e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "525b278ce098cc7db35e67ba9b646b4fab11b336165e8154b8182b74fc080a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "c4240dcdf6441c43f6843b157eea6234f91df256c778d70a25bf2529d4c0f22a"
    sha256 cellar: :any_skip_relocation, monterey:       "a41ee9274c1ce3ac32efaf68e39e1dbd23c6b1200edba87b29ac0348c7934e93"
    sha256 cellar: :any_skip_relocation, big_sur:        "679aecf0ff6c8e8ad66673e12430c00c48ee8c36ca975cefb72cc576fb4cfacf"
    sha256 cellar: :any_skip_relocation, catalina:       "a3cb7962ec480fc511d09b8c4ff730b472ce275e5502de686667a2d34da378ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85fa3fe5e540fc474f73817e7936bd01544b5b36786701231336ef1dd99e6ad"
  end

  depends_on "python@3.11"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/31/8c/1c342fdd2f4af0857684d16af766201393ef53318c15fa785fcb6c3b7c32/iso8601-1.1.0.tar.gz"
    sha256 "32811e7b81deee2063ea6d2e94f8819a86d1f3811e49d23623a41fa832bef03f"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/1c/1c/899994765c0395caec18b3e5381e61bac256c35a43f80fb468f3de689f95/jsengine-1.0.5.tar.gz"
    sha256 "f9676bad44904483f0b17bf2838b07893c9fbaf575f2153e46735b767243199f"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/e7/ee/4c675ee27a03fcfda19e5bdeb52de1ed8f3383e27c04c6b1246345b550a4/m3u8-3.3.0.tar.gz"
    sha256 "2b1f4ffceb6c488b9d87bcbbd22f7fb92afd8965ba161d882f29e9b23dcb1939"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAwNjY3MjU3Mg==.html"
  end
end
