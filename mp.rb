class Mp < Formula
  desc "Minimum Profit editor by Angel Ortega"
  homepage "https://triptico.com/software/mp.html"
  url "https://github.com/juiceghost/homebrew-mp/archive/v3.2.13.tar.gz"
  sha256 "176aea01f4334605ea0cc89caf7ab0a0c600c8367b8a4779fcb7d54983af1dac"
  def install
    system "make", "mp"
    bin.install "mp"
  end
  test do
    assert_match "3.2.13", shell_output("#{bin}/mp --version")
  end
end
