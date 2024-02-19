class Vulture < Formula
  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/da/70/29f296be6353598dfbbdf994f5496e6bf0776be6811c8491611a31aa15da/vulture-2.11.tar.gz"
  sha256 "f0fbb60bce6511aad87ee0736c502456737490a82d919a44e6d92262cb35f1c2"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a358e6d21716ef06c8b469c866a823e2512b1a118ccf7228fbdd17c5c727027f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61d19219b3199b1c000c1c8c124ff0e937fda861fffede3e45cee63e8c775035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2519a4b5abe2e39c5f4e851c12e5540907f9f30ff27b34bdfb775821e71327"
    sha256 cellar: :any_skip_relocation, sonoma:         "abec129caa65c07a84818daf8fb458ee3291111db9180261e166162f5108c68e"
    sha256 cellar: :any_skip_relocation, ventura:        "425c7334b3b7bcf7fb9eeb3379229db6472dcc3be6b9639d54d2023383150b9e"
    sha256 cellar: :any_skip_relocation, monterey:       "a37a8c3d834920979f268b1683f6db015f7e6b9dfd5ee1b600846b4aa248bae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f6b4f4c33053e4f2e22fe9f090066beb906de180259ddec58ee6819aa7bbf5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-toml"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")

    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 3)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
