class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/0c/93/3002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147/yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcac343ee478ef2cda7b9083d5e444c4e0d550a3536705511dda07cfd39ffa97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcac343ee478ef2cda7b9083d5e444c4e0d550a3536705511dda07cfd39ffa97"
    sha256 cellar: :any_skip_relocation, monterey:       "e178118b37492c4e6c8cfbf2cd2a6a94a99e25138eb2aa5b2217ec3e239bdd6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e178118b37492c4e6c8cfbf2cd2a6a94a99e25138eb2aa5b2217ec3e239bdd6c"
    sha256 cellar: :any_skip_relocation, catalina:       "e178118b37492c4e6c8cfbf2cd2a6a94a99e25138eb2aa5b2217ec3e239bdd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9122a6c3d55c3db4779f8d71f2de14ffd0df050c78136afd59ef482638078c"
  end

  depends_on "python@3.10"
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
