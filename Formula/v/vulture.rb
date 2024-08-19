class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/da/70/29f296be6353598dfbbdf994f5496e6bf0776be6811c8491611a31aa15da/vulture-2.11.tar.gz"
  sha256 "f0fbb60bce6511aad87ee0736c502456737490a82d919a44e6d92262cb35f1c2"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc27fcab671d00e8f19313417662667b299ee104d6b9102b0c37d8f781d317b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7a4609f073de1e1de08c520846fa47cb61750634bdd8aae17e8f833bc063df2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "608759a9a3646d3881845e32432eea74beb25e0a535c4d33c2694487c4523841"
    sha256 cellar: :any_skip_relocation, sonoma:         "107b5810debf92f63419f76f8d133e52e957b3cc06af6f6561cde20e5bcc0cf9"
    sha256 cellar: :any_skip_relocation, ventura:        "ff5676c7547d371566895e5311745535c740f7f1a5e2f967331b9ac21d20ea6a"
    sha256 cellar: :any_skip_relocation, monterey:       "72972d743b216e538def092020c2957b7fa93acc418d8c11733d4fcbf2f79f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9921574e7c525d24edffb5dd0b6629fa79918d85aa2b01923f9dadcbee83aa5"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")

    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 3)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
