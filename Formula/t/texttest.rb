class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/0b/e0/4c6eb823436d221ccfeec099c228ee5c477483693fa167f0c70a3b55e5e4/texttest-4.4.2.tar.gz"
  sha256 "144c9ac050e836ef1aa7a5668519640cd449b8b7031513348d5fcbb9f6623952"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7659944882f48484ddc33338131c281f32cd382c5d0790a6a631c223da7a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3752a2afe8de0a8a810ecc64c538d405b30dd967a446b71dc507fa37b9d0f5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "471631388fcad4b8d56fa54a18f7040211c7992e2ad81d44a88bf92a8de713a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba57a4b5a86b503059223870a76189163bf3b816947c969cf6de569427de292e"
    sha256 cellar: :any_skip_relocation, ventura:       "f18ed2a3a25f41a54b2155c7a1e171cffb35f389d4a95d0e80c820eeae615a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a001e34e0c48f5b9cf3c3d887655107834523e7bdfe481c2e273915f0cf65f8e"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1f/5a/07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cb/psutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
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
