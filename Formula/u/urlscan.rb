class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/e9/17/ef014dd0323fd063c4948136dea6cb9fb0ef739539d3245e34dfbbd57349/urlscan-1.0.8.tar.gz"
  sha256 "15c1dc59a2c0c9d697acec1e4823f4a801aa79c176eff603c93d79b413003757"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1eacf4173845d925cae61292b6fb05a8b11322fbc76e220674f3c440c012e897"
  end

  depends_on "python@3.14"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/bb/d3/09683323e2290732a39dc92ca5031d5e5ddda56f8d236f885a400535b29a/urwid-3.0.3.tar.gz"
    sha256 "300804dd568cda5aa1c5b204227bd0cfe7a62cef2d00987c5eb2e4e64294ed9b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/95/fc/44799c4a51ff0da0de0ff27e68c9dea3454f3d9bf15ffb606aeb6943e672/wcwidth-0.3.5.tar.gz"
    sha256 "7c3463f312540cf21ddd527ea34f3ae95c057fa191aa7a9e043898d20d636e59"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
