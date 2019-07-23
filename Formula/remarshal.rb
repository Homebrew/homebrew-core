class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://github.com/dbohdan/remarshal/archive/v0.11.2.tar.gz"
  sha256 "3f383e48f59722a4d93ef2b5e417b6a8c152f382a1faad416099ffcde5c87a66"
  head "https://github.com/dbohdan/remarshal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d89cb1474b2d8275c839dd1a217ded6b6490916f88b982ef0b795917fbad8c2" => :mojave
    sha256 "fee3008d49e74c91d7d9bdbb3facd129a1b1b723cf6796e0d3a97c85e848b0ef" => :high_sierra
    sha256 "d9c441f5965a000215be453be7c810ef7f471517629cbfaa92eecc8d3a28ce05" => :sierra
  end

  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a3/65/837fefac7475963d1eccf4aa684c23b95aa6c1d033a2c5965ccb11e22623/PyYAML-5.1.1.tar.gz"
    sha256 "b4bb4d3f5e232425e25dda21c070ce05168a786ac9eda43768ab7f3ac2770955"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz"
    sha256 "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/d4/6b/b2deb0763305a2de35c4d125bfede7b0e414b7c18fb43011b554b9ce1832/u-msgpack-python-2.5.1.tar.gz"
    sha256 "6c02a0654a5e11f8fad532ed634109ed49cdc929f7b972848773e4e0ce52f30c"
  end

  def install
    virtualenv_install_with_resources

    %w[toml yaml json msgpack].permutation(2).each do |informat, outformat|
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
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml), pipe_output("#{bin}/remarshal -if=json -of=msgpack", json)
  end
end
