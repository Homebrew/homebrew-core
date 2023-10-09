class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/2c/73/13f76208c9e6312e27bd6d5f62ff867746b7c075b9451448803dc13b2834/rpl-1.15.5.tar.gz"
  sha256 "ae13d2fa1c1b8eaab75ff5756cbea9cc6836b55c4191e332521682be69de1b83"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbdc2e93963b5aa74c10ad2f52869531598b949d62d074c574964c79ee2b8542"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c712f5ef9d147506f523633646c7a0deed5f9b3f636db9046f123e3bbaa5fc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69dce64c5577c2131b59bbed061c81420895bf7be155f9757142a61dd38412c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3611591866694f72ef5fcc1c2e4b7a8d03191d33638d2bd4e91fe914e04695c7"
    sha256 cellar: :any_skip_relocation, ventura:        "0b24ac685484027510af56652804fd1ebd93c97b630fc6db056e7b27d97e3bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "284da2bec6f3130d957f77bfbe540ac1b5743c7d8a6b6896f6017b917544fb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c911e194bb3faf879554ea55ed18bd25045f294c1c0c4467605371b1830ef1c"
  end

  depends_on "python@3.12"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
