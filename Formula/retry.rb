class Retry < Formula
  desc "Command retry for the shell"
  homepage "https://github.com/kadwanev/retry/"
  url "https://github.com/kadwanev/retry/releases/download/1.0.1/retry-1.0.1.tar.gz"
  sha256 "3df0d341e7973be0752b468e5d84643559ecbeb40e959c0b2ffbc2fa42616e1c"

  bottle :unneeded

  depends_on "gnu-getopt"

  def install
    inreplace "retry", "$IN_GETOPT_BIN", "#{HOMEBREW_PREFIX}/opt/gnu-getopt/bin/getopt"
    bin.install "retry"
  end

  test do
    system "#{bin}/retry"
  end
end
