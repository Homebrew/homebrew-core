class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/8e/1e/730a64d83e1b6a64bb8efa5358fc8e9418e6c2d19862523dce22be1040ed/yapf-0.29.0.tar.gz"
  sha256 "712e23c468506bf12cadd10169f852572ecc61b266258422d45aaf4ad7ef43de"

  bottle do
    cellar :any_skip_relocation
    sha256 "c22d7f03bd8c89b8b1d4fc150bc24839c70dc994207d9cda55ec2a722eee4e24" => :catalina
    sha256 "c8de7e9be2a3c5c8a09501199d4beea2accbd5a62471a6def5495899b8facc33" => :mojave
    sha256 "a819475f27f0182bfee9ae5c3a63fb60af1119c78fbea7509954fb1fe035986a" => :high_sierra
    sha256 "c5be10b759aaa579aeafb7b6a0d941aced581d9ab5428198ea588f367c37809b" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
