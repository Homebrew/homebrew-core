class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/9b/e4/aeb20cd0ba6499835d024bd40ff63b1d655bfdf1d185473d58e97dacb74e/yamale-5.1.0.tar.gz"
  sha256 "b26052bb1d5d2260b4bc2996449e11ede1e4963a8b2a37305eff2da0c6455342"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a029a6c7bc916eb9c7a91dcf9d12558c03c05b0672d5ffa1e9c34fff6480f73b"
    sha256 cellar: :any,                 arm64_ventura:  "12da0e3667692cd2e6754e9d3c1c8a90361bef13b00d7212280c281ffc444eed"
    sha256 cellar: :any,                 arm64_monterey: "0c8beff50ce57372ee513e11ff128b37264964d1af49231584e17825d9ce850c"
    sha256 cellar: :any,                 sonoma:         "c2c46775086edb3b14ce2c2b646ba45943bddaeaec6aabc1a9e9c5840e217faa"
    sha256 cellar: :any,                 ventura:        "e1ca4625870e3fb5a3bebcba4edbef1ae525fe4d4eec343259c1effd5030af5c"
    sha256 cellar: :any,                 monterey:       "401c1358f9872b55b70f854ce41319e82ae8c27786a21b672f63145bcfea562f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b918125d3bc85dd58cba75e7cbd03ea2321fddfda3da78ec3054205345ec1b3"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
