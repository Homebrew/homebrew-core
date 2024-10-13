class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/a1/52/0faa32aa15f241a9f950ded276c942db69bce8dda5f19241f6b960080dca/yamale-5.2.1.tar.gz"
  sha256 "19bbe713d588f07177bc519a46070c0793ed126ea37f425a76055b99703f835a"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "972e3519557190a2fb6f6b22c98b61fe538d5624b14da8d34e0bfa553a30ab92"
    sha256 cellar: :any,                 arm64_sonoma:  "9bc34bd97e2f3b863536b6d5a496a8d1e302a2c82d9e502a7fe9b5ce292e2928"
    sha256 cellar: :any,                 arm64_ventura: "59d8b6c4c7d427f1ae7a5d7e12020372d12d9dac4e84112583d928c145062c9c"
    sha256 cellar: :any,                 sonoma:        "a5b74a8255fd2673d509c7a5d83261c3091d62d756552e5f487e3fa011a2db38"
    sha256 cellar: :any,                 ventura:       "4771d6bf1e8781dc07095dfc196702fcebad4d668e7cdce136b81e1e0f01a4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8896fa98af8cd7309abc1ae9a63ea54da11fdac0029b397481f9644f236fe0e6"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"schema.yaml").write <<~EOS
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    EOS
    (testpath/"data1.yaml").write <<~EOS
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    EOS
    (testpath/"some_data.yaml").write <<~EOS
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    EOS
    output = shell_output("#{bin}/yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}/yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    output = shell_output("#{bin}/yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end
