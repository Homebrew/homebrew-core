class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/5f/44/d68632e248a2b64399b5cedcc2ff19ee2f1408cdaca6b57a88c00c65f63e/yamllint-1.31.0.tar.gz"
  sha256 "2d83f1d12f733e162a87e06b176149d7bb9c5bae4a9e5fce1c771d7f703f7a65"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53f3c7903eaeb3d30cbbcd274543630b4bca01b4b96bd3f01d6a9799c7766248"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49801b4c46a1a12c1f1290e6f4fbe6088547b91c54ee3c3a925e90cdfdb01ee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee50b9280e263540533d0399f23b33c6769dd6fa4024fd0ea9b50184d358989"
    sha256 cellar: :any_skip_relocation, ventura:        "9870e8d4699fb36a3fb45b30b56c31e318cca50e7fbd35d561b9b3a89384d59c"
    sha256 cellar: :any_skip_relocation, monterey:       "f0778a3c27d3f34eda9e9334aed31b85175e6e59c1385902dc0539a60904add7"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b1c39e31746ee79e6067937b57f4d5e577a229b9cac5229af9601042f26a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802a95e5c466c8583614272ba48a3328f85aad6387e91d1c9708ed31649cfc01"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/95/60/d93628975242cc515ab2b8f5b2fc831d8be2eff32f5a1be4776d49305d13/pathspec-0.11.1.tar.gz"
    sha256 "2798de800fa92780e33acca925945e9a19a133b715067cf165b8866c15a31687"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
