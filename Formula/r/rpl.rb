class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/f0/85/81cd913d43251f923a56b44586c717f41e8ff5e4ea35d2ced60e9de00bbd/rpl-1.18.tar.gz"
  sha256 "378d38de283f6682f85e93695396f3461d719778e17a8013f64bd87d7f671d7e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f3a92c152aa85e38ecfa5e723ac3976e7c922bad0a11541fe4fffdfbaaac227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027eb212bc7e4016600eec213bf22696297124dad33d0c1ac476c6b833677dc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "161eab6b8c8144193155d77567883c9ffc7421a2047217c51cfb4766e20ad3fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c8fbc594de8ca5db2fed2073a9b20fa736c2a5a413ccb5037d4ad544e078350"
    sha256 cellar: :any_skip_relocation, ventura:       "52b0ecfa8e85d9075f871a7de4a4e86c51f31cc8cbc0458ceeea1e3552b5ebec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61dd2a865b8b0922685c91436bea042c9b5d52a51b1e301ff6c5c1bc7ba2eed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07d8974cf495884f8d2a663b0e15b9864f05733d0b6e1333567703ff05cbca2c"
  end

  depends_on "python@3.13"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/a5/cc/93357fd1f53c61fdc6111a6d9ea2cc565b2c1be9227c15bb036a0db0396b/chainstream-1.0.2.tar.gz"
    sha256 "b32975d3b3d1c030a507ac298044c28fa3ca30d527abdfae281edd53276617b3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
