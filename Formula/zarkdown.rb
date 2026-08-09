class Zarkdown < Formula
  include Language::Python::Virtualenv

  desc "Zarkdown - 键盘友好型纯文本标记语言"
  homepage "https://github.com/yangzizhoudiwuxuande/zarkdown"
  url "https://github.com/yangzizhoudiwuxuande/zarkdown/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "963d118f63883567eedb150d6207884fffe315f94e3abb420500a7bfc5a7f4e4"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.zkdn").write "/ 标题\n\n?粗体? 和 *链接*(https://example.com)"
    system "#{bin}/zarkdown", "test.zkdn", "-o", "test.html"
    assert_predicate testpath/"test.html", :exist?
  end
end
