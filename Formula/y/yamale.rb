class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/9b/e4/aeb20cd0ba6499835d024bd40ff63b1d655bfdf1d185473d58e97dacb74e/yamale-5.1.0.tar.gz"
  sha256 "b26052bb1d5d2260b4bc2996449e11ede1e4963a8b2a37305eff2da0c6455342"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93aac388fcd9e9eac86664fbf861f47e176f63de8c5825f15aac6f3979042b07"
    sha256 cellar: :any,                 arm64_ventura:  "0fcc69f665110653a1d77729388932ba1f5ed20e789b711a561e10cc182ed72f"
    sha256 cellar: :any,                 arm64_monterey: "2a78731e2b57463d5e9c16e6c1779c8cd977169251c6d08587760c8705e4664f"
    sha256 cellar: :any,                 sonoma:         "d6dd1f0c441dffc38a8d14c73a633f98e47bb8d1356ffe5d16cbb55b0cf9073a"
    sha256 cellar: :any,                 ventura:        "255b612151df695aa6ba0f3f661c30effb131b36c0b8f76998fc85eb3c650574"
    sha256 cellar: :any,                 monterey:       "d20eeeefa31a4695208616418ac2914cee98a91e4469925ae510e91228c67dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b9de997a035362a7317e54a4f70ae489e2e651c7553951f6b54a86aa071f02d"
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
