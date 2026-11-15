class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/0d/e0/9e33a713d45f31f9ec5f8a8a7b3edd188a5a22cec9340be1637dbc539b08/urlscan-1.2.0.tar.gz"
  sha256 "27ffbc49a98da0f3d0a533b23e04c71784d4e10fbf2ee4e1f443ef39364fce5b"
  license "GPL-2.0-or-later"
  head "https://github.com/firecat53/urlscan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c60c3331ca35e51bf612954664183bd02ae615b7d5330e7f91ca46326a68e73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db794f758d3d607b98d8c2684e294d59893570dfec5aa26a35880e05faa75785"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fc6bcd3a26192b3fc1365a2d148804a7b5d2f6ffda34b61fbc15dc218c1e385"
    sha256 cellar: :any,                 arm64_linux:       "777676c3d49f4aaa9722c4b5a64a06b00e0563bec8206f2f69ea3d9ebf25e4f0"
    sha256 cellar: :any,                 x86_64_linux:      "e631815fc8c8b9433013c03f32751daf616af6b6d49fc74ccd6bb7ab5f2ebc89"
  end

  depends_on "python@3.15"

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/3a/df/eb5dcbdf1638c38618096382b4a30b0423ed7d2aac97fd9469b51d6de43f/urwid-4.2.5.tar.gz"
    sha256 "a1fea3a551953fae4e6b727536334233bbb8b88c45230bc91d9751b402a8c16d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
