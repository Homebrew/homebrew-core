class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/1e/a2/8d68c0f5bfda82033fac0d36875c185241de37e1ac56f8b3f161e825a1e6/ykdl-1.8.1.post1.tar.gz"
  sha256 "97b179ef7059685fbbb24d4f50ae6e5e01f08e9c0998b292dc1ca44c1af09dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80783c02f77ce796ef7d9ddd0abb1f3864a1dfaed874ca82fd8fc187c221e513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efcd0011857332ef15e74cdff962bb60211200796eaca797ace08cddcd9f5ba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05b27c56f6e69dd6bc8f914b5d614d3bc8732455e8ff3e22f6e1c099cae0476a"
    sha256 cellar: :any_skip_relocation, monterey:       "d39d2294ad69b40a6fc0be6a7ab3f481a056d61452768319171ea079d5b7da63"
    sha256 cellar: :any_skip_relocation, big_sur:        "73612c966a51b6fb49249ee41fe1da2d44e32a3bd3282657ce5194d6889dea7a"
    sha256 cellar: :any_skip_relocation, catalina:       "5a7973f5eb02f8e2c19dc88ab403e2b9282be2cbc88ba19b008c41829c70380e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d7c1b79b55252269492d73da787c3216d607b1b86b8e94e07ef895172de531"
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
