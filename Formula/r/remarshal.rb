class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/remarshal-project/remarshal"
  url "https://files.pythonhosted.org/packages/16/0b/ad91623d00c9b362604ad9c4244143f706c48db6e768e2cd26d1fe56dd79/remarshal-2.0.0.tar.gz"
  sha256 "42669d5cf9efad98050ea6fcf5aa22780ef8dc2399e8ead34776397e7d01fd3d"
  license "MIT"
  head "https://github.com/remarshal-project/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "298a87cb16e889df7a7f34c1772878977ede8e94ce1ce273755b7b06908eddf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e658b8c806dc2bb51fe9291fce13306f427ebed10cb25867a446fab7446dc529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab1125ec9c44e678f67003dc34e17902e380256cb987db86f1acf6467d57ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e47f8e5bc37545ed7acfcdea3540e36c3ce9f1d1d1aa99f0755c2a3481e00e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f53e8124184c2f04053dba979f801eee518b69124a02f4a8117312319f3c1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81576440a6eb0d0f79dffb05b4ee87d0ffe4176c7061f88cb7618fc5cb8740e1"
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
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
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
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/6a/e5/1064c43203a357d668cd42435f7a15fe6af51512d85b2104fecb937aa861/rich_argparse-1.8.0.tar.gz"
    sha256 "679df3d832fa94ad6e4bdb07ded088cd7ea2dddc58ae9b2b46346a40b06cbc0c"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "starlark" do
    url "https://files.pythonhosted.org/packages/39/5d/153396eecab3d698fbaece5be2e049607b7eb8eb5bdf8955d58751f3e18f/starlark-0.2.0.tar.gz"
    sha256 "998e67a80a717344d601acb4e9de392f111b82e78c58e6a7bfeb0534c50f3f54"
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
