class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://files.pythonhosted.org/packages/a2/98/8becf6a4ead798c1a517715fddfb73a8867ac58d833179a30f0dfc3dadf0/remarshal-0.12.0.tar.gz"
  sha256 "1df0016b3ad47e78e0d4d016a0e0cc7ad5cd6a60232e8dcbc89af4ccc42eb172"
  head "https://github.com/dbohdan/remarshal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e239a6f7fed381016f36bffa0e287731b5e2bcb61334b8f2d9efa88b88918f1" => :catalina
    sha256 "eea1d2b51cc88366a1da55464cf58545286f9d26a74c9e93fca775dab47db006" => :mojave
    sha256 "8fa23a4540ddb0cc04b0f25ce5faa83ca0dc31a456cb6da28a94e8a7365cde2a" => :high_sierra
  end

  depends_on "python@3.8"

  conflicts_with "msgpack-tools", :because => "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/ee/80/bc617b7fd89855649e48eb8242e09535e1b75371ec8389313fa0f97e2a70/cbor2-5.1.0.tar.gz"
    sha256 "43ce11e8c2fe4971d386d1a60cf83bfa0a4a667b97668ba76acbf5e6398821aa"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/f4/ba/98ee2054a2d7b8bebd367d442e089489250b6dc2aee558b000e961467212/pytoml-0.1.21.tar.gz"
    sha256 "8eecf7c8d0adcff3b375b09fe403407aa9b645c499e5ab8cac670ac4a35f61e7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/75/c4/d9404382d0f7d9be27b5d13498d033a4faa83f325b3893e1c29a0faa83b9/u-msgpack-python-2.5.2.tar.gz"
    sha256 "09c85a8af77376034396681e76bf30c249a4fd8e5ebb239f8a468d3655f210d0"
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
