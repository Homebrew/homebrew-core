class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/37/27/da3742a358015f3c2a069ccdaf7e5766ac358e8200319f640755db3128ae/yamale-6.0.0.tar.gz"
  sha256 "60be681f35e4939320b89de0d6f187ee0e5479ae7f7286b7f17f0859ddee4a66"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e48267ff74adef8ba5d4d66834e837278195007081f1ba45e3b9142d17edcc1b"
    sha256 cellar: :any,                 arm64_sonoma:  "84c923dcb48dca1e6eed547ce3768edc50d1cf4a357cbbe777b76e0cf9d1df50"
    sha256 cellar: :any,                 arm64_ventura: "7a25c95c119ca7c208907a8a8f96555ceacaeb99ca3e33742127a1024293461d"
    sha256 cellar: :any,                 sonoma:        "da45cebb15964ac288acd319dc2bf59553a4248ee2e0ec33959267b3fe684ac4"
    sha256 cellar: :any,                 ventura:       "5d79479b30e4a0b9060051b53726d56cc6b96cd7a5e107584b5ca4459d6ad259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "206664ef4991756e905b44123fac164c8f8d05baaf348d90064b22240acd3eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef4d6178db727a8de6d7749a1e03f2fafe21384e58b20f7e29d2bd1f35450ca"
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
