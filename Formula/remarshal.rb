class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://files.pythonhosted.org/packages/24/37/1f167687b2d9f3bac3e7e73508f86c7e6c1bf26a37ca5443182c8f596625/remarshal-0.14.0.tar.gz"
  sha256 "16425aa1575a271dd3705d812b06276eeedc3ac557e7fd28e06822ad14cd0667"
  license "MIT"
  revision 1
  head "https://github.com/dbohdan/remarshal.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8521482cf34a60440f479a03265a6e7d8620ccf100496a6720f92eed4af11145" => :big_sur
    sha256 "b0c1b75665dca786bde756d4af9c520a8663cc940a9c7b10a105d447e14ec2c2" => :arm64_big_sur
    sha256 "204004c532be6254a8366067b285e5d900c0cb6961ad47e589d03f7cbd4eed55" => :catalina
    sha256 "608a1f16ab92f54dc4fd3479633b86e62de3bf51df2f8f7b111f9312141576df" => :mojave
    sha256 "1a671dcd4a208faf7e12bc97154d6f67137b2463d2f4d17ed1841785c4cf41c6" => :high_sierra
  end

  depends_on "python@3.9"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/02/15/f4d7fb47753099fcd9d7f7c81920d422a3ab2e710400ec0f4a1b511b51ae/cbor2-5.2.0.tar.gz"
    sha256 "a33aa2e5534fd74401ac95686886e655e3b2ce6383b3f958199b6e70a87c94bf"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/64/e0/6c8c96024d118cb029a97752e9a6d70bd06e4fd4c8b00fd9446ad6178f1d/tomlkit-0.7.0.tar.gz"
    sha256 "ac57f29693fab3e309ea789252fcce3061e19110085aa31af5446ca749325618"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/c5/2e/af1a0964bf3cb31559852ba0e82944bf3bdb70630480d49f262e5bf6e264/u-msgpack-python-2.7.0.tar.gz"
    sha256 "996e4c4454771f0ff0fd2a7566b1a159d305d3611cd755addf444e3533e2bc54"
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
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml),
      pipe_output("#{bin}/remarshal -if=json -of=msgpack", json)
  end
end
