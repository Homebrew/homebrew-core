class Unoconv < Formula
  include Language::Python::Shebang

  desc "Convert between any document format supported by OpenOffice"
  homepage "https://github.com/unoconv/unoconv"
  url "https://files.pythonhosted.org/packages/ab/40/b4cab1140087f3f07b2f6d7cb9ca1c14b9bdbb525d2d83a3b29c924fe9ae/unoconv-0.9.0.tar.gz"
  sha256 "308ebfd98e67d898834876348b27caf41470cd853fbe2681cc7dacd8fd5e6031"
  license "GPL-2.0"
  revision 2
  head "https://github.com/unoconv/unoconv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be1cd33331c14eca168e7667eb571f23ebd5c8023cda1a388405d7f88991e94f"
    sha256 cellar: :any_skip_relocation, big_sur:       "34695d78b10bb265c9164e262dca4d3321c18bf8f9622c59377f3b8f1e7771d0"
    sha256 cellar: :any_skip_relocation, catalina:      "21013d55757dbd1d67143f3a3d44dfad73a948a84bcbc323a9be2770d103702b"
    sha256 cellar: :any_skip_relocation, mojave:        "8f9de5f5019bfae60563a842de0894f8436bc6a988c87ab407eac02eee99188d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ece3a0399c4f7ea93b1d04e9cb01915b615f680116ab372bc33a27c20d0346a"
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "unoconv"

    system "make", "install", "prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
    EOS
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoconv 2>&1")
  end
end
