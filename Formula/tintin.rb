class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.20/tintin-2.02.20.tar.gz"
  sha256 "331673e6ee3c945cf27e1c0d71cec1225c9d992588ed73b2a707c4c49523e8d2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ebbbc301281083b40f6681ce3e3c305261cfdfa8ff5539b814e0eff7b8a55f03"
    sha256 cellar: :any,                 arm64_big_sur:  "73d0bbde0e88409ccc7a46c0aea1df8fd50c627f35d9e90fe3f2fa9d2c07467b"
    sha256 cellar: :any,                 monterey:       "66816b03eff95a19f251bf229e312482c87458bbbba2b24e04b39cdc6bad1b26"
    sha256 cellar: :any,                 big_sur:        "a2c52474736bbf2789f2595d045b9257c92fd547d8943ed023fc14d99e96cd52"
    sha256 cellar: :any,                 catalina:       "38f0217f785c1218c73f2dfd066d27e551d6f4930108a8b69524b5f11b19010e"
    sha256 cellar: :any,                 mojave:         "23d1eaf2dd6b6a14b167353b6edcbf6934c58b5c105451e44377a30b29e46f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61815e3d0602667ddac1ba5eec6601f051baf43d267b9f2fec6ecfbea74eb2e"
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
