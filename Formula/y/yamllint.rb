class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/46/f2/cd8b7584a48ee83f0bc94f8a32fea38734cefcdc6f7324c4d3bfc699457b/yamllint-1.37.1.tar.gz"
  sha256 "81f7c0c5559becc8049470d86046b36e96113637bcbe4753ecef06977c00245d"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4241606602e0cab66eeec59f791c2a65fc6f46d9d83b903418c16892facba5be"
    sha256 cellar: :any,                 arm64_sonoma:  "f98d6db2e13c8ba481acd4d15df4bb6a2a861a7af3e3bb64facfa45863d5424c"
    sha256 cellar: :any,                 arm64_ventura: "306d5cdfa177ef0e748beacbafb5aa19883978f18ef6fdf937a7f21aed35c8fc"
    sha256 cellar: :any,                 sonoma:        "f140abc3afa4e130c96fb66db179374b0c196ce62159e97aaf8321450f8a69cf"
    sha256 cellar: :any,                 ventura:       "0abcd51823ae770c1f1e02ae64c36eaa593d5b3b9a4b634c112e731161821b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb3caa7cb9e282692efaede364d93f2c725402252dd7f87c28baca3f7848c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce938787e6e7d11348544aad521f22cc82b22f332b6842e92003dd75d662e7c8"
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
