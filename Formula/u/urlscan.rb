class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/d2/1b/83a6cfd26a4037d7271713f8aa51750fdfc5c850c5ebc93161073fd03b6c/urlscan-1.0.3.tar.gz"
  sha256 "9df791861f0baea1d9c7254f9f98ed23fc193219bbd4edd1c4fcfce7d14ef7d7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10a0cd18040ebe8c431bb7364085760d117f568d4b0b71daec5504c37bc7bfde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10a0cd18040ebe8c431bb7364085760d117f568d4b0b71daec5504c37bc7bfde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a0cd18040ebe8c431bb7364085760d117f568d4b0b71daec5504c37bc7bfde"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcabb1d71f7ee1a077c1eb3c7a6a38710aaf0740a75644549d029b1da1324466"
    sha256 cellar: :any_skip_relocation, ventura:        "bcabb1d71f7ee1a077c1eb3c7a6a38710aaf0740a75644549d029b1da1324466"
    sha256 cellar: :any_skip_relocation, monterey:       "10a0cd18040ebe8c431bb7364085760d117f568d4b0b71daec5504c37bc7bfde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c892249cdac2dd6e5aadd9295d1c8c9a2ca148265d4e4d7a32358d37531716"
  end

  depends_on "python@3.12"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/b7/516b0bbb7dd9fc313c6443b35d86b6f91b3baa83d2c4016e4d8e0df5a5e3/urwid-2.6.15.tar.gz"
    sha256 "9ecc57330d88c8d9663ffd7092a681674c03ff794b6330ccfef479af7aa9671b"
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
