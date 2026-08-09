class Zarkdown < Formula
  include Language::Python::Virtualenv

  desc "Zarkdown - 键盘友好型纯文本标记语言"
  homepage "https://github.com/yangzizhoudiwuxuande/zarkdown"
  url "https://github.com/yangzizhoudiwuxuande/zarkdown/releases/download/v2.0.1/zarkdown-2.0.1.tar.gz"
  sha256 "963d118f63883567eedb150d6207884fffe315f94e3abb420500a7bfc5a7f4e4"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/zarkdown", "--version"
  end
end
