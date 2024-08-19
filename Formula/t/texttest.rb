class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/7b/14/e52c96906f1d397c776c4940f68e9b44cae6b1a1aaba915c372638c3b48f/TextTest-4.3.1.tar.gz"
  sha256 "8c228914dbedbea291c3867c844bf32487306ada2a2cb2e3b228427da37bc7cb"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae3a79098c5ee58b1cb655e7b2295edd208201c21683ccbbe5f759ede6feb19e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf446711e2a3519c3e8d80c044a65e569e656f81db55454f5add3f9808c2c764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fdef508725b2daec109bf60c342dc4f4d2d5f5dbab07da0f18ed5c4f9da580"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a7b0e5bb949d8d82148d5b6488bcfc5d936ef5c184d6b298aa97cb7cad94df4"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4c642521fd8bcb1a1f9bfd6443db1e34f76a6a14c2fabc2ba8d911a00343e3"
    sha256 cellar: :any_skip_relocation, monterey:       "a1826bcdea50ad49534c149df8f516874a2aee2d8441e10478413521e2e95165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65185cb0ea5cc2599c779abec776178b829b78a80d83baaffc8d60ccda25ab67"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
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
