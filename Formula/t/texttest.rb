class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/57/df/27a7fab4593b4f39f0664631af6fb14768014f04b033262409c8a2bf1fa7/texttest-4.4.3.1.tar.gz"
  sha256 "9916452bcc1b8413547142b0966f8710c2feeb32822c553bc9b3265fe8f29314"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aac453cc16155c4892c4cff979edc6562acc547955ee4c9240e3acdeedfac1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ff1ad9f9c7ed257a2ef6e84bb1d498629ba64bab9f9938391a159203f662d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8d7b7a4826de374e7414534591609dfe3aa111dcdd7a97760451307900095d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e831db453a20deab3af02382342054bc1b5e4e80d2611d4e78b63169b2807b1d"
    sha256 cellar: :any_skip_relocation, ventura:       "935d18c9bedd751a7acb64eec6cb7571e8673a8d0c5e9fb7024b6aa1c263dc9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ffc29e1deb1313dbea1455f09307d7879bf51c198507654fdc118a7fccb3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c202f3d700abfdb9f4246882e0ac47beb7d644bb9576521c255145cddd7a0c7"
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
