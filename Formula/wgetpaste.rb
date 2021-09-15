class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://wgetpaste.zlin.dk/wgetpaste-2.30.tar.bz2"
  sha256 "e3ec35f1ff49f2204864e3b4d784f6c032cdddb62cadf69263900c67a4896592"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?wgetpaste[._-]v?(\d+(?:\.\d+)+)\.(?:t|bz)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0344acd685dd364fe3d0d09fb4f872e400b83360b6a7917e2afca40f7225b6d"
  end

  depends_on "wget"

  def install
    bin.install "wgetpaste"
    zsh_completion.install "_wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end
