class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/5c/d2/3e3923b54bd185352b68359f60728529c0eae30fcef8e01eee0e7c3978af/urlscan-1.1.2.tar.gz"
  sha256 "e4f01037dcb84f0cc5733b9423732ebf368cb9b4c9714bdaf7dd336d883a78b2"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7fc22a1945eddfbb9d59a4c9905e8cc6f66590496f41e63d226815660f876f1"
  end

  depends_on "python@3.14"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/79/ea/0a61a054016f6592ac9a430723bdbcedbbca9630a2781e70d2df189afe84/urwid-4.0.9.tar.gz"
    sha256 "99bad59b4c7b5bf87bd86196be4554ef93a031947f2a84f0fb090d8162b6ffc5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
