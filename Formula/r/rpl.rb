class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/9f/1d/3ee12488a69bfc3857636e262247f4b1d28eb149431e27fff5b0af0266d4/rpl-1.15.6.tar.gz"
  sha256 "e2f52715fc623efca0f60b708901379c76419ea06d055c21337290ce48f3c3f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "083e8e4e93cf1cdc2d27927a5fcc9d940cf5836a627a56eb7909c53c2aec3cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "304dcb7bae1af1dd89e70a7f251b085e8cbdbdf854a380085a7455cf2a6cbd02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eafe2b59387da30fbb13720583057ca3918c640a65e29c1122e67a9ea88bbcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e88507cb5ba53208592f4af66acfd4ea87e12fe96518022fd62e48af4b6f158"
    sha256 cellar: :any_skip_relocation, ventura:        "dae63f9ab024feeff2322915a4d6f72305c6dd043f67241fc8f53fe9d7a1d107"
    sha256 cellar: :any_skip_relocation, monterey:       "7104efc1ff0ff1ae068c4d7909d507e10f57bb455ca06c5162af566929eccb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c195d7aafecce96a9a509ef41ff8647cff2fc38d0886814d80ec6e92a4be02a"
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
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
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
