class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/4e/82/b2b6fa4c3e24df501d14eff23100b37e6d9f80cbed80644de4d1260ff402/yamllint-1.37.0.tar.gz"
  sha256 "ead81921d4d87216b2528b7a055664708f9fb8267beb0c427cb706ac6ab93580"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca8c91dda9670df3d4c0d19ee505cbd705ad1bba0d91345bcd86061ebbfcfbc0"
    sha256 cellar: :any,                 arm64_sonoma:  "127df47ee3ad4dc2bd4035b05137baf43214b2ea3b90f5368d6f955c5acf39a3"
    sha256 cellar: :any,                 arm64_ventura: "2f43d0b636a8b1ef3b0d86f44e5d7c5019d343249eabb41ca8b585dd732f519a"
    sha256 cellar: :any,                 sonoma:        "450facf1da1044b6e5c9e2b114b8fb47e02f89c5bb79cd42b7ad65ab0b47ad90"
    sha256 cellar: :any,                 ventura:       "3e7893f7f1ba19439cac81de5111e8ad6ff651315cd1dfec1abac197a016f6f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa8f195bdf53b883395dc33df7731e113985af5830f72f993a7652519d6e037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412ee67c482e368cdebdbf58c7ac51b050a81c91ffab778668558ca6c4a31e6b"
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
