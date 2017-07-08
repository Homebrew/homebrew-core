class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://github.com/dbohdan/remarshal/archive/v0.7.0.tar.gz"
  sha256 "785f1928e3522671a21eb2e0ce7b6882e8589ccb195b4ee49dec2403fe3d6f4b"
  head "https://github.com/dbohdan/remarshal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d438958d7e38569511885690e6d0580ed79e1334ad42c607ae8a85089fc51d29" => :sierra
    sha256 "18bdb665c453752f578f9cabcf147395f2e8ac3665a4180ea5670d7f674bc8bb" => :el_capitan
    sha256 "7e40d76cbb74f12dc6e38c7465e02c30962ca60dd32c97443f0e669501ea10b1" => :yosemite
    sha256 "7441f7b5f5b2fd8d6eccd1316039110f65b6cd9e37c191bdb8566c3af16f2641" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/6d/2a/c5a0eb781cff59df8613a531f07f9d82bb47ea595aa91c6f114f1621a94a/pytoml-0.1.14.tar.gz"
    sha256 "aff69147d436c3ba8c7f3bc1b3f4aa3d7e47d305a495f2631872e6429694aabf"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources

    ["toml", "yaml", "json"].permutation(2).each do |informat, outformat|
      bin.install_symlink "remarshal" => "#{informat}2#{outformat}"
    end
  end

  test do
    json = <<-EOS.undent.chomp
      {"foo.bar":"baz","qux":1}
    EOS
    yaml = <<-EOS.undent.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<-EOS.undent.chomp
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
