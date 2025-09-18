class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/2c/86/5287f0801f09ce6f380569516ae2928274234016ae25cf24b5719814973f/texttest-4.4.4.tar.gz"
  sha256 "0ea7ce2846ef261c8de575775b4f64471d0a2d0714719237216bbb1bfb5a995f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb9b37df685485270c05bfcdb017e2ecd1f6dcf3f004b5995042733624f53ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e7191ed85dc361be7f5bf9e347c478a7ec548c78740f729d13861b6e801fce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3020337061ac37ea1f694c72e75b0fdcb19ddd1eff922956629870091a3185"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e327e89d05204683bda5e8bd799f7b40eb20ec89294d34e84ef04d5c2cfe515"
    sha256 cellar: :any_skip_relocation, sonoma:        "c012cf7f8ed85c00945604a78b93f3e3ecf3786e56c5dbebf5ea326bbb5ece5f"
    sha256 cellar: :any_skip_relocation, ventura:       "74d479d24fc3d719de60ac1fc179a840fadd1600097c50074ab4ad94b5676880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405d9322bcaad19db7074eaa3adf66f67e2f82a520d771809f4fa53652bb106c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71f95fe11e952b8ddbe339879354761f70c673898be9af66cf189ad00776f58"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
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
