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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c36beb1cd7fb1ef865ec2aa9b3fcf7e9616b9b541acb2190c359e809c373963f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281c90e07cdb5699d117daeb35bb2610d32d8f9acfd92e751a3e5555f22c0f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d169ea5d55078749f1234d20327e8e9784840edc4f7d42e9791c95af0b03430d"
    sha256 cellar: :any_skip_relocation, ventura:        "0111dc0cf3723ae11d2209a840dc3392af776008b8fddf7755726b6d018e2143"
    sha256 cellar: :any_skip_relocation, monterey:       "b991e129653532f96e7f2a91322bd21ded8941181fb4a4e1e09d64dcbd9e87d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2715ea7cf3d0e83b5a418b7faae7e2b2074f56c30f0251302f8a98f8bf22fb68"
    sha256 cellar: :any_skip_relocation, catalina:       "eb5b30cc63466ed94f6ecb486e4bbfc09876b69d26c2e37456363b3f81131db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42e99b958e0e3af16a50b7387a5d2abea0c5a412f6cafe2d71138ff1dc2e5e95"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/9d/c9/cfa5c35a62642a19c14bf9a12dfbf0ee134466be1f062df2258a2ec2f2f7/cbor2-5.4.3.tar.gz"
    sha256 "62b863c5ee6ced4032afe948f3c1484f375550995d3b8498145237fe28e546c2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/44/a7/1cb4f059bbf72ea24364f9ba3ef682725af09969e29df988aa5437f0044e/u-msgpack-python-2.7.2.tar.gz"
    sha256 "e86f7ac6aa0ef4c6c49f004b4fd435bce99c23e2dd5d73003f3f9816024c2bd8"
  end

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # Remove when merged/released: https://github.com/dbohdan/remarshal/pull/36
  patch do
    url "https://github.com/dbohdan/remarshal/commit/4500520defe25433ad1300b46d1d6c944230f73d.patch?full_index=1"
    sha256 "32cba193c07a108b06c3b01a5e5b656d026d4aecc8f5b7b55e6a692a559233f0"
  end

  def install
    virtualenv_install_with_resources
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
