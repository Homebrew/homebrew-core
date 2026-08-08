class Zarkdown < Formula
  include Language::Python::Virtualenv

  desc "Zarkdown - 键盘友好型纯文本标记语言"
  homepage "https://github.com/yangzizhoudiwuxuande/zarkdown"
  url "https://github.com/yangzizhoudiwuxuande/zarkdown/releases/download/v2.0.1/zarkdown-2.0.1.tar.gz"
  sha256 "a4ae11dcbf3b89ad273ac2755ff4b1d0937c80a23a7de71ad33f27fec14bcef0"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/zarkdown", "--version"
  end
end
