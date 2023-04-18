class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/25/7e/704143fd83b6d13d8d146730bd01d10b73d9eb78137f7ee52fec7ed3c594/yamllint-1.30.0.tar.gz"
  sha256 "4f58f323aedda16189a489d183ecc25c66d7a9cc0fe88f61b650fef167b13190"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e48760cd61aa821b263077fb123ec5883b204006e4465e0e9498b314c70f4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "824bc9dfe283be5d80c20c65359e9b72419574378173c147b45a7f6906a53ed2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34e5c84909e5de30410c7688a6ed80698f1bd193ba29fcd6b2820f4c96617b5"
    sha256 cellar: :any_skip_relocation, ventura:        "23580d4eb305d08a304ccdd52c5c443923a6a4bd57b7e8fe23a6e62f0dfb3ce3"
    sha256 cellar: :any_skip_relocation, monterey:       "f4cf06199f8afb3ed51f6d790417cb38dcbb3d16b95614c8a800093dbdba6d0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7697fe5c9a4e47120e95893b9b28310e9b144550ede127622bdce1b3cfd2086a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f870bd463043da954c37dbf18b809733afaa607f150cfb6ba56b16f91f52cb"
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
