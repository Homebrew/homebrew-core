class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/88/96/10143ccf034ce03a92e299530d877862c3db59de4dc1fecbf5dc6c73960e/urlscan-1.0.9.tar.gz"
  sha256 "067087895077762807ff028ed332e4e1ab6e1a7c249188dc846f6d160afba7ff"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f55b54c7f10b4bdb6e968a642e7406561709dd50721772caf42c7eaa162b051d"
  end

  depends_on "python@3.14"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/98/b8/9ed1c288eb7e9236ee83a3f847d15dfa879841219b9a7d174c6c2ef33f53/urwid-4.0.2.tar.gz"
    sha256 "6962bd04ab98002326b67a431c59b2fb35e8b5abe2e095feda3ee7d8ea8f1228"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
