class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/af/95/4c28f3cfdb866f9a6e301fbafedb0e537dd40c8cf9d33872e67ed38ec1d2/urlscan-1.0.7.tar.gz"
  sha256 "041b932f94cb1e2e8dbb20f43322da85cb483be328fa10477c6e5e96a89891c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f06e24ee723a5d356f9b82a54abf7c29f3104c509865c4a014d948f306b73bed"
  end

  depends_on "python@3.13"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/46/2d/71550379ed6b34968e14f73b0cf8574dee160acb6b820a066ab238ef2d4f/urwid-3.0.2.tar.gz"
    sha256 "e7cb70ba1e7ff45779a5a57e43c57581ee7de6ceefb56c432491a4a6ce81eb78"
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
