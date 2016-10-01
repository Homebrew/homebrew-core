class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://github.com/dbohdan/remarshal/archive/v0.6.0.tar.gz"
  sha256 "19e85b010ada81f3094ce4e607d6f26aeb2ea40c92c4c704fe1cdb8fd8f637ee"
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
    url "https://files.pythonhosted.org/packages/f0/10/e47db5fb819505674b2be4f8c2ae9f29aed840e81569761d6b6b7bf59954/pytoml-0.1.11.zip"
    sha256 "a9aa2e60b254b9e33c8e44562465516cb4db3ae78e68502e881ac6e0ea6a0cb6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
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
