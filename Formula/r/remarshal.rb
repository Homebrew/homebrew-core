class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/remarshal-project/remarshal"
  url "https://files.pythonhosted.org/packages/c8/04/12595c827f1a3dfeadbb9c1b112e9b86c229e69f56b1696f0d4b5df40957/remarshal-1.2.0.tar.gz"
  sha256 "f50950a1cca59efddaf54cd86b70377f12a4120970f3bc8a694b6c5c23ef7898"
  license "MIT"
  head "https://github.com/remarshal-project/remarshal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9cd2da8a2078ef3247621e850eb1e148ec5ee79330eee02e0e4b739093ad44a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6842a3fedb2cb14aabaa5efef8d36f92edd5ed98020ae918026e1ff17cfb063b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d8e129b8e8902e72b9d44e2f8578e1b30548d7f2fc7da4708ca6dd7ff1ed87f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ebe6422c42ef9f1d396d34c13ada34ad3b7bb35bc929d1c1dc194a567840a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b4bf66764531c341cf21b78b5413e818574350655beba390c389068ac65392b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df8a6b09dd4258057e39b612809a021173b907fd42353f2a5d579d730b70c0a"
  end

  depends_on "python@3.14"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"
  conflicts_with "toml2json", because: "both install `toml2json` binaries"
  conflicts_with "yaml2json", because: "both install `yaml2json` binaries"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/3a/89/01df16cdc9c60c07956756c90fe92c684021003079e358a78e213bce45a2/cbor2-5.7.0.tar.gz"
    sha256 "3f6d843f4db4d0ec501c46453c22a4fbebb1abfb5b740e1bcab34c615cd7406b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/71/a6/34460d81e5534f6d2fc8e8d91ff99a5835fdca53578eac89e4f37b3a7c6d/rich_argparse-1.7.1.tar.gz"
    sha256 "d7a493cde94043e41ea68fb43a74405fa178de981bf7b800f7a3bd02ac5c27be"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {"foo.bar":"baz","qux":1}
    JSON
    yaml = <<~YAML
      foo.bar: baz
      qux: 1
    YAML
    toml = <<~TOML
      "foo.bar" = "baz"
      qux = 1
    TOML
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json, 0)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json, 0)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml, 0)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml, 0)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml, 0)
    assert_equal json, pipe_output("#{bin}/toml2json", toml, 0)
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml, 0),
                 pipe_output("#{bin}/remarshal -if=json -of=msgpack", json, 0)

    assert_match version.to_s, shell_output("#{bin}/remarshal --version")
  end
end
