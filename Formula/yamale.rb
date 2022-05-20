class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/0c/93/3002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147/yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "040701592f7094e0a62283f27beb26a50a88b9fa57144a37c10834d4089eb6a6"
    sha256 cellar: :any,                 arm64_big_sur:  "0ae82976d2035d60f74c02dadc6f310f90e33c82f59da219548e3deeb0828576"
    sha256 cellar: :any,                 monterey:       "a3a41ce391718c31c8e3d69e325d291a97cd4934ad4e6858ee396dff1bd046b1"
    sha256 cellar: :any,                 big_sur:        "2cfdeb143c82684703eda15fce3dd1c0952880290d7b9bc0bf8ac118ce4dc176"
    sha256 cellar: :any,                 catalina:       "7934ecc0c302b42a9299dabc1c9e84ecee369acad40a90274eb3dece581c7ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e1c449bb2b823cdd4bbdbdac6a4c865e9bea6cac4baac10e1e05661667d8c0"
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
