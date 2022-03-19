class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/0c/93/3002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147/yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d532329e0f7a9c7b2db439f5c5fe41230bfc10c5eb2bebd18c0837fac826ad8"
    sha256 cellar: :any,                 arm64_big_sur:  "6713e352fecb60b6c0f1d5c5a3dbdb1d666107f8cfd8418d7cc3582e7215ad53"
    sha256 cellar: :any,                 monterey:       "312dd4532c330fb8eaabf4c416d98a4417e228c7c70ecc2972ede093ed4c5b1e"
    sha256 cellar: :any,                 big_sur:        "75c24b1d0dd4f1f96eb3e097bf7eeeced2992285527b0385e8df91412827cbaf"
    sha256 cellar: :any,                 catalina:       "e8263be2cbf128b3e0ba900c1d25d7977522dfef7f1d07d89e30e6754faec0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "354b48357ed0d614c6a96819caded46b1899e569d99b235938a786bd87c31d8c"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
