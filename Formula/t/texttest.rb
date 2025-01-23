class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/78/ad/26a9b4447d1a6692119b2600606f813755bb44eca72640c95cbad92ecf2a/TextTest-4.4.0.1.tar.gz"
  sha256 "f80ba8a65d048de52a038f3d125a5f47cb5b629e50a7a7f358cff404a8838fa8"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391bf3cb3b1c414c96e37c5bcc5741dbb1ae059cbe1251224194fd7840a6f661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4865496f4043e96bddef882094a7e08d3056a151990a1a83305500a500bd0092"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf6c82b4a760c1f02612c560b6ab04b8bbc4a0d1dc2c193730607a7fe10bdd79"
    sha256 cellar: :any_skip_relocation, sonoma:        "55ab51362a999050f962fe162c66e18f7237816b36d8ac38bb59fa117f580f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "a3ddf9f6dd0b68726f98e3e3f888359ed46c8739bd82ad90662533814e3e5e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d792f108c5f2b916e3f2dfd4e45d5bd29df80fa5b58ad6fe347db24fe37fec61"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  # Remove `pipes` for python 3.13
  patch do
    url "https://github.com/texttest/texttest/commit/9ee930d60a42058b541cc872acdf5aca2471a983.patch?full_index=1"
    sha256 "181c2a5a4d09703686c801f3f0894c79b17a48f56dc4bbd549030b58eadc2b9b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
