class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/f0/85/81cd913d43251f923a56b44586c717f41e8ff5e4ea35d2ced60e9de00bbd/rpl-1.18.tar.gz"
  sha256 "378d38de283f6682f85e93695396f3461d719778e17a8013f64bd87d7f671d7e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f30ceeb460bc67d3594e702e9de5c42ba913a5388515b754d6225542e6d18fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db734192128a7e60d98bf9d06faa0086d0abfa483201e93db0e877c20566b91f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f80cd4cfbaebbd99d7d4f99c4484d88335707ed458253fde37653e1928cf904"
    sha256 cellar: :any_skip_relocation, sonoma:        "47fab5f6519ffeea8846065f66842a6b13b2e825c2542f93065ea0e3aa42bb8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a50d816a8cbc804290630c63e1a7a4fae2fdfc702ff3424db8d6dd1ce8a875ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bb1e34afdd4f02172a30480efb626a835b70e988fe37b020aa4312d0453f02"
  end

  depends_on "python@3.14"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/a5/cc/93357fd1f53c61fdc6111a6d9ea2cc565b2c1be9227c15bb036a0db0396b/chainstream-1.0.2.tar.gz"
    sha256 "b32975d3b3d1c030a507ac298044c28fa3ca30d527abdfae281edd53276617b3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
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
