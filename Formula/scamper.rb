class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230224.tar.gz"
  sha256 "396c9297c56fc5aab37d345dad386929d2072053e77f2c6a01e79c0cafd1b5f9"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c45d04260cb4685343c62081d99ec5e883ff0c29b2b0c2dd7d4f2618f3698fc4"
    sha256 cellar: :any,                 arm64_monterey: "fbc6f10b913a5cea28abf1a0ff291a9e43cd9ed13c24ef90310bb0d2d1d89c56"
    sha256 cellar: :any,                 arm64_big_sur:  "3b60fe6585a586a24821693c8e0d82d3b3b2d74d7cf531756c880283aca20be4"
    sha256 cellar: :any,                 ventura:        "a83f3fcc0ced8f30ebcd409d6f29d03991d412feac0d32b18e10bdba761d8a5a"
    sha256 cellar: :any,                 monterey:       "4c3637101ba885cdfb5ef11a760a2fe9ed7d1ff333743c17132c00c972fea1be"
    sha256 cellar: :any,                 big_sur:        "c3b86754ee156a63ad9a16dffd883424e0c71b57bf90f889ac29da42afa191a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a076e30566dfa088be382a3bb97ec8cff93dc37e87f4a81cbbe00b2eb5de756f"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
