class Recoverpy < Formula
  include Language::Python::Virtualenv

  desc "TUI to recover overwritten or deleted data"
  homepage "https://github.com/PabloLec/recoverpy"
  url "https://files.pythonhosted.org/packages/86/bd/9613e994031ad1af3408db0ed5973562461178de8d85920f202e3d4bcf93/recoverpy-2.1.6.tar.gz"
  sha256 "3b6f1eb510e46c85fa7631628f708b430f682ee308dbe0b07ca0f03b488be1fc"
  license "GPL-3.0-or-later"
  head "https://github.com/PabloLec/recoverpy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a115db07f42385106c98ea8d00d422334f6e9338143a8fb916473c6ab6b84e52"
  end

  depends_on :linux
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b4/db/61960d68d5c39ff0dd48cb799a39ae4e297f6e9b96bf2f8da29d897fba0c/mdit_py_plugins-0.4.0.tar.gz"
    sha256 "d8ab27e9aed6c38aa716819fedfde15ca275715955f8a185a8e1cf90fb1d2c1b"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/64/b3/d33af0cacb5d8838e65b9d591ce5e47a063e1a0eba736568f3c222aa004f/textual-0.51.0.tar.gz"
    sha256 "ca3d58c00a360ef1988a9be2dbb34d8a8526f2b9fe40c2ed7ac6687875422efd"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = fork { exec bin/"recoverpy" }
    sleep 2
  ensure
    Process.kill("TERM", pid)
  end
end
