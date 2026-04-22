class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/remarshal-project/remarshal"
  url "https://files.pythonhosted.org/packages/8a/60/3847a729b9502f176d85b0e7f81dbe27b8124cbb43e896f3c79cc74e5faa/remarshal-1.3.0.tar.gz"
  sha256 "21778b0839d691c141cd3325ab70be8529f1ce1c5fcfac8b4673fd1b2dec2f85"
  license "MIT"
  revision 2
  head "https://github.com/remarshal-project/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af9f6e878525d8c12ede7c9c08255d4f03e039fcc8cafb0c19f50db5f88d3c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a356f57b5445201b305cd82e5289f5335739df5a6329616c0e7380a72e7b88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f67ced465f831b1395bf7b97094b9b3b8eca270873a7bf8232110e654537294"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ffeb86a192ee6fff3c4d19c71ca41c6e4210df1e60c2351ef9b5d51076d69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a3c6bd2a9ac7ef916606f9d94ba610d9303b2b9974de46c504bccb4f6489eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1d0a595861b0e337a28f2576d0b1cf202d53aa2e73901a3e422b8ea5d610f7"
  end

  depends_on "python@3.14"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"
  conflicts_with "toml2json", because: "both install `toml2json` binaries"
  conflicts_with "yaml2json", because: "both install `yaml2json` binaries"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/bd/cb/09939728be094d155b5d4ac262e39877875f5f7e36eea66beb359f647bd0/cbor2-5.9.0.tar.gz"
    sha256 "85c7a46279ac8f226e1059275221e6b3d0e370d2bb6bd0500f9780781615bcea"
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
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/4c/f7/1c65e0245d4c7009a87ac92908294a66e7e7635eccf76a68550f40c6df80/rich_argparse-1.7.2.tar.gz"
    sha256 "64fd2e948fc96e8a1a06e0e72c111c2ce7f3af74126d75c0f5f63926e7289cd1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c3/af/14b24e41977adb296d6bd1fb59402cf7d60ce364f90c890bd2ec65c43b5a/tomlkit-0.14.0.tar.gz"
    sha256 "cf00efca415dbd57575befb1f6634c4f42d2d87dbba376128adb42c121b87064"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
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
