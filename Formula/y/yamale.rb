class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/a1/52/0faa32aa15f241a9f950ded276c942db69bce8dda5f19241f6b960080dca/yamale-5.2.1.tar.gz"
  sha256 "19bbe713d588f07177bc519a46070c0793ed126ea37f425a76055b99703f835a"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c5ebfc81864613bdd1e30f35b1348f8be32ca92b08874a5902e4d1c01c57917"
    sha256 cellar: :any,                 arm64_ventura:  "a7fa0ea6519e357eb573b4ee47d1983e053ad7bf3cc7d29185b536fa11bd77f5"
    sha256 cellar: :any,                 arm64_monterey: "8660b24b84321ada3030da4ac73cdf1ac2081325bf5da3f92fb1592fdee5faec"
    sha256 cellar: :any,                 sonoma:         "64f86dc528e57efa4788f112f9383534de827877292f09fbaa005c6970065897"
    sha256 cellar: :any,                 ventura:        "e311137d5bf6b7eaffd9553111dc3d7d5d98a19b15dddd0f947fad621087979a"
    sha256 cellar: :any,                 monterey:       "83f1931bf8bf30f857e277163e8ce7399e8bf7b50e6208c456973d2832818b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806207e26ef328f9fa8c96457fb2eaa8c3d27b6ff8ac5049209f3d87dea69eaa"
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
