class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/29/50/fd0b7b1e1f36327521909236df2d6795baebc30b4a0cb943531ff6734eb7/yamllint-1.32.0.tar.gz"
  sha256 "d01dde008c65de5b235188ab3110bebc59d18e5c65fc8a58267cd211cd9df34a"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e570c23b0e864eebacc24d449617e974e4f0775c49d461c289d820d751507957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11a034426062d3f2fbc21f5e1d9d4e78149e7f4e6cef07add6356e9634dc2bbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503dcc5dad52c1c0aee8cfb6be53a92ddc1c4fcb5966b1d2e2db9db4e9e7fa5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a982cfd2beec85466f26017fc8b5c487a87927b60760381a7793266dab238695"
    sha256 cellar: :any_skip_relocation, sonoma:         "a05cbc42676437ec603d684de9c1895fa5906e0e8e68d33906aba9d1190d38bf"
    sha256 cellar: :any_skip_relocation, ventura:        "bbffb9cfb8706c2c80a6726cc04e67d372b2d740b1a03f4fade95a727cbea233"
    sha256 cellar: :any_skip_relocation, monterey:       "ddadbcd884d946943799bf2802255d18ec4c15a03093909c54da1850923c100e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e640cdb1e1a6ecd37cffe2be518414263842dd46fa2ee05dc0f70251615542e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fdb5f2a3b54744ed76215cb4f1aeb491194b244dfb16b2a929b97e7a03de7a0"
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
