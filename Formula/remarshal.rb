class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://github.com/dbohdan/remarshal/archive/v0.9.0.tar.gz"
  sha256 "e763cd57f4418a537c9a4e219e43bc5153303a2041af673fda682a3767fc0d5d"
  head "https://github.com/dbohdan/remarshal.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b712854f25a498770ff04dab6f675279763ee0b7b1d354407135e80368d8e418" => :mojave
    sha256 "44582cb5294bd6f84f5488b9ed3872656b732c81504b6063b104d1244614ab08" => :high_sierra
    sha256 "f5006481444b6658f07ecbb7106a99291671690ffe45e6d54ad40372a4c92c20" => :sierra
  end

  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/35/35/da1123673c54b6d701453fcd20f751d6a1fae43339b3993ae458875576e4/pytoml-0.1.20.tar.gz"
    sha256 "ca2d0cb127c938b8b76a9a0d0f855cf930c1d50cc3a0af6d3595b566519a1013"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources

    ["toml", "yaml", "json"].permutation(2).each do |informat, outformat|
      bin.install_symlink "remarshal" => "#{informat}2#{outformat}"
    end
  end

  test do
    json = <<~EOS.chomp
      {"foo.bar":"baz","qux":1}
    EOS
    yaml = <<~EOS.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<~EOS.chomp
      "foo.bar" = "baz"
      qux = 1

    EOS
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}/toml2json", toml).chomp
  end
end
