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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1f61a1bcde49a8572b1e1425fb8157a971475f137b9152a28cba937325bb367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c537c470d33b0e448c03a34754f95fcf6738bebab5a8484eae74448a5a0df737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72b85ac20f3ab3d3a8172294dd1af9830c2337da5e3a8b90a95cc33e67213a6b"
    sha256 cellar: :any_skip_relocation, monterey:       "87c3e6cc0bd24eba5749faae9deafdcd7691759c65d2f0a8a2f985b54c060815"
    sha256 cellar: :any_skip_relocation, big_sur:        "63043b6846a31a0f5f65dde4564a9c58f00b58c51daa2125fd616408815959be"
    sha256 cellar: :any_skip_relocation, catalina:       "e9bb6247fc4e693b99f3d0075e04e315d54c996d8cafd7a2193c074f7e0b770e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eb6f74d4dbd9fb9614adde6170a05faef95cacbd91e991fc5c403914b62b49a"
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
