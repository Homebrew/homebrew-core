class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/78/ad/26a9b4447d1a6692119b2600606f813755bb44eca72640c95cbad92ecf2a/TextTest-4.4.0.1.tar.gz"
  sha256 "f80ba8a65d048de52a038f3d125a5f47cb5b629e50a7a7f358cff404a8838fa8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc1c69c3f5345a46b8535b92673050a5c82d31650606ecd77608eb84ac4488e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26c9c52da71db1e254d9ad5e3d918a5981be9bf9b2faac0fd72939d2a861ed24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ac848ac36fd4ccc0a6ff06991dc47ad07957b55e63ecfaf0cac42b9fa9dfadf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5703d6f6451ac2f053faadaf365d2b0370652eb82d466ee0c164faa77ff8ba8"
    sha256 cellar: :any_skip_relocation, ventura:       "34af3df65e4206cda6bfd5d4657f93a3595a60f59e84d26a87db8619a86b827a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2fb823176296ad78796c2446350dbf7bdfa66de7de00a10ee2e4fbd195627b"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
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
