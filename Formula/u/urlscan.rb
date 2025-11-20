class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/af/95/4c28f3cfdb866f9a6e301fbafedb0e537dd40c8cf9d33872e67ed38ec1d2/urlscan-1.0.7.tar.gz"
  sha256 "041b932f94cb1e2e8dbb20f43322da85cb483be328fa10477c6e5e96a89891c3"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "17b62b76b4b04fc9fbce367ffbed2cc3514882e37eda4495d9232032eedf1011"
  end

  depends_on "python@3.14"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/bb/d3/09683323e2290732a39dc92ca5031d5e5ddda56f8d236f885a400535b29a/urwid-3.0.3.tar.gz"
    sha256 "300804dd568cda5aa1c5b204227bd0cfe7a62cef2d00987c5eb2e4e64294ed9b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
