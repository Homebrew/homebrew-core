class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/0c/93/3002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147/yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74b1479ab1daeaeb8e1a0048d1ed067c08ff38d7a69817fad6685f4480242959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74b1479ab1daeaeb8e1a0048d1ed067c08ff38d7a69817fad6685f4480242959"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74b1479ab1daeaeb8e1a0048d1ed067c08ff38d7a69817fad6685f4480242959"
    sha256 cellar: :any_skip_relocation, ventura:        "d3f3df5c8bbfa6008780dae17e10f985f5ec4e6e9f3fdb62190eacc31e33b094"
    sha256 cellar: :any_skip_relocation, monterey:       "d3f3df5c8bbfa6008780dae17e10f985f5ec4e6e9f3fdb62190eacc31e33b094"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3f3df5c8bbfa6008780dae17e10f985f5ec4e6e9f3fdb62190eacc31e33b094"
    sha256 cellar: :any_skip_relocation, catalina:       "d3f3df5c8bbfa6008780dae17e10f985f5ec4e6e9f3fdb62190eacc31e33b094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6def822a1d3f765f4b8d0ba7c95d5d8a1e6a48fe737128ddaa7b60a6fff6c41f"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

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
