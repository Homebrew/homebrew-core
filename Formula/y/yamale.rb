class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/da/64/9e5de0e829920b848dcf5fe3ff64936d83cc7471babd264588b08bca97e0/yamale-6.1.0.tar.gz"
  sha256 "fd435aa7b830c73e89a9ef548c0ace2d3d8dc3e5e180e6b57ff70b31495672fd"
  license "MIT"
  compatibility_version 1
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "623f6f77e7574a43e43ab2517b1df3de366de687e0ad15fb0d6bf3c6c177a978"
    sha256 cellar: :any, arm64_tahoe:       "0cbc5945ca2f3a5e7640f225a7cc68ad26df0ec12497b5ffecd33956fc2b40fc"
    sha256 cellar: :any, arm64_sequoia:     "226b343afae317a7f6667b9216131499457d2bf817ba151715386b58aa56c993"
    sha256 cellar: :any, arm64_linux:       "331cfe0382a46001a4de2f5520a3ce6260a684565b5ac9bdd2a98e7dffd1b029"
    sha256 cellar: :any, x86_64_linux:      "9f8ccec565c6092758145e6c2bd4e8e37ac9b5d9d913b63346e72eee55dfc740"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"schema.yaml").write <<~YAML
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    YAML
    (testpath/"data1.yaml").write <<~YAML
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    YAML
    (testpath/"some_data.yaml").write <<~YAML
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    YAML
    output = shell_output("#{bin}/yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}/yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath/"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    output = shell_output("#{bin}/yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end
