class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/27/23/57d2d0a002a77638c2f3196d24d966209f51c498413ac1758d1680a0f96a/urlscan-1.0.2.tar.gz"
  sha256 "d909ff180588008faba8a6491e3e0821ad3c8a3b6574b94fd73b8fb11ff302f2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aa227256b751c0800fc64164b8b34ae6fab1a096f5d8bb4599dafe934e7f83d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aa227256b751c0800fc64164b8b34ae6fab1a096f5d8bb4599dafe934e7f83d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa227256b751c0800fc64164b8b34ae6fab1a096f5d8bb4599dafe934e7f83d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aa227256b751c0800fc64164b8b34ae6fab1a096f5d8bb4599dafe934e7f83d"
    sha256 cellar: :any_skip_relocation, ventura:        "4aa227256b751c0800fc64164b8b34ae6fab1a096f5d8bb4599dafe934e7f83d"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa227256b751c0800fc64164b8b34ae6fab1a096f5d8bb4599dafe934e7f83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eafd40467f3ab691249ea1850abc9fea3c9919bc53f4867d7dbd0c6c2483865"
  end

  depends_on "python@3.12"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/ef/fd/77d351caa11c438c7536bba12ea26bb1f22fe7fd0d9aa65849d4625c3e2d/urwid-2.6.11.tar.gz"
    sha256 "52770007d734d7387ae0421e7b7769c4c5ec67e91a5f4df54e858e314062e475"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    man1.install "urlscan.1"
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
