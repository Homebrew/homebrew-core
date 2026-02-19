class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/da/64/9e5de0e829920b848dcf5fe3ff64936d83cc7471babd264588b08bca97e0/yamale-6.1.0.tar.gz"
  sha256 "fd435aa7b830c73e89a9ef548c0ace2d3d8dc3e5e180e6b57ff70b31495672fd"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d49d4d42166eb67fa258a430f4613fa9a1a74ab48a5839900a2b0459f8401635"
    sha256 cellar: :any,                 arm64_sequoia: "07e32a73e8b5ee15ef397cc29984d3fe2662a1d598409c868811bdcb939cd09d"
    sha256 cellar: :any,                 arm64_sonoma:  "477bb88ad9e1dc07e77657718fd205a646c2a64b670b51ee14161090f7775dd4"
    sha256 cellar: :any,                 sonoma:        "50e2564584208d180dc83c80200f3bac4813f1d4e9c80124de6beb9667155a4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb5b04b9d77edb9bb5f85dc39742c4dbb4cb616957b97bc6c6b59ec5b95ff26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09591168c37d57139676c401f7eff3b9d80bfec138919f1ccb5c76b0f18ce0be"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

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
