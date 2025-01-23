class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/da/06/d8cee5c3dfd550cc0a466ead8b321138198485d1034130ac1393cc49d63e/yamllint-1.35.1.tar.gz"
  sha256 "7a003809f88324fd2c877734f2d575ee7881dd9043360657cc8049c809eba6cd"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "cb74d6cc51501733531acd25b26fd474557d19374b98eb7de16271ff2c257860"
    sha256 cellar: :any,                 arm64_sonoma:  "e36b43d6b87028fe2005878cb15c78edec6ddb898e9a86ff7b901fe093cf9c0e"
    sha256 cellar: :any,                 arm64_ventura: "3591f98aaaebba5e9360926f5ca756dbd85c6a46de0554042376ac83548c7fb3"
    sha256 cellar: :any,                 sonoma:        "3889369233f5f342b73cc70625748a52d72117603b92f352af00a9ebd27cb1c4"
    sha256 cellar: :any,                 ventura:       "209883378df0edf4a0691fd2dbf6f2e8da7776bd9c0de0fc70fa04dd0fc51c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993514320174f1147d538719552131a73d34cf66dc9f82c38f6ed28b16cea287"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~YAML
      ---
      foo: bar: gee
    YAML
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    assert_empty shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
