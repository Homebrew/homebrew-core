class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/a5/ae/2622262d7a5c6af2af85e5edd86f4cf183628e88407942aa0be487b582b6/yamllint-1.29.0.tar.gz"
  sha256 "66a755d5fbcbb8831f1a9568676329b5bac82c37995bcc9afd048b6459f9fa48"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ce7abb1de9cd41d661929fcbc7d85215eae1afeafe148d3fb2cc1f72d6e678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54b87eab00c4b653aae6c11296c086a14a3b0f45c2751b586529f5c1a1d956d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8994da7382a322ef7aec71c18ac818878987a58c8e1d1722c5e7c6108cf612ce"
    sha256 cellar: :any_skip_relocation, ventura:        "3f26ac3b19e15ce2ad16a32a515dcc7ab03577a3327a9cc97b4bc543fcf73329"
    sha256 cellar: :any_skip_relocation, monterey:       "3f5fadd1eefef12870422f062355ce3b2db16958df23ee8a45b58ce4d1454a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cea8e16be7992edf6fb75636f412b3892e01bd07083246aaf1f5708c44ccdc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e530006efc9ac84535e7806415de537f1d9576b2070af651bd92662767a420"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/32/1a/6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08/pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
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
