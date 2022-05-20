class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://files.pythonhosted.org/packages/24/37/1f167687b2d9f3bac3e7e73508f86c7e6c1bf26a37ca5443182c8f596625/remarshal-0.14.0.tar.gz"
  sha256 "16425aa1575a271dd3705d812b06276eeedc3ac557e7fd28e06822ad14cd0667"
  license "MIT"
  revision 3
  head "https://github.com/dbohdan/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f6bd3e96392bcfa62be9d9c67d6aef33b9d18da54e657d4c26a37f38ca20b2f8"
    sha256 cellar: :any,                 arm64_big_sur:  "17886e23ddb3e6dc1824e195a5bbe2e6f65b08f750c61fe149f0cad9b95d3e40"
    sha256 cellar: :any,                 monterey:       "dcb1b2b8cc49e3a2a7091531f1c37df9fb47852035d56c659a90bab72c552173"
    sha256 cellar: :any,                 big_sur:        "35e9b3686329a3a49410078a62efa4a1a47d247c61b4806a2baebb4cca2f6285"
    sha256 cellar: :any,                 catalina:       "d3556c7f66d0e0e293a27a249a5096cbcf5036656afabb9e7b80d95b8470e28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b23018ebe711328bfe03cb664f4ce1f143ea136546807565bb1c100cbaf5e7d"
  end

  depends_on "poetry" => :build
  depends_on "libyaml" # for faster PyYAML
  depends_on "python@3.10"
  depends_on "six"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/9e/25/9dd432c051010faea6a702cb85d0b53dc9d5414513866b6a73b3ac954092/cbor2-5.4.1.tar.gz"
    sha256 "a8bf432f6cb595f50aeb8fed2a4aa3b3f7caa7f135fb57e4378eaa39242feac9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/62/94/a4f485b628310534d377b3e7cb6f85b8066dc823dbff0e4421fb4227fb7e/u-msgpack-python-2.7.1.tar.gz"
    sha256 "b7e7d433cab77171a4c752875d91836f3040306bab5063fb6dbe11f64ea69551"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
    venv.pip_install_and_link Dir["dist/remarshal-*.whl"].first

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
