class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  license "w3m"
  head "https://github.com/tats/w3m.git", branch: "master"

  stable do
    url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3+git20230121.orig.tar.xz"
    sha256 "974d1095a47f1976150a792fe9c5a44cc821c02b6bdd714a37a098386250e03a"
    version "0.5.3_git20230121"

    # Fix for CVE-2023-4255
    patch do
      url "https://sources.debian.org/data/main/w/w3m/0.5.3%2Bgit20230121-2.1/debian/patches/0002-CVE-2023-4255.patch"
      sha256 "7a84744bae63f3e470b877038da5a221ed8289395d300a904ac5a8626b0a9cea"
    end
  end

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/w3m/"
    regex(/href=.*?w3m[._-]v?(\d+(?:\.\d+)+(?:\+git\d+)?)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "df1fa11c7bee916e98b1dee448030ab78a7ce622c1a3a1a3ef7937a5898ea3f5"
    sha256 arm64_sonoma:   "efae67d8d635d8f05a27fc9ae4e75156bffa465828735428e3dfb6d1a117b6eb"
    sha256 arm64_ventura:  "fc4a77c30411f61b24a69be7ac380d6f79d3e9617c47f18f9c26e9c7a5ae11ef"
    sha256 arm64_monterey: "f987092472928a6f55bc65930ca911de4415f312cf9c9b8f3662baf4058b4b05"
    sha256 arm64_big_sur:  "d777d1b1193a49785df6150d908e38db8b2de415432f4acc55a635be32e69f64"
    sha256 sonoma:         "6a3667e99c6b8a5a0febbbe8567ed3a6a712d8421e34176cc2a51c7e20019fd0"
    sha256 ventura:        "9403514e48aabc3e5ed768524465eafa7bb5b5f1f67f3a128fe98a1fbae4aaa8"
    sha256 monterey:       "9e6a1fc7660ebab1bce04646cc625d107b43e0a5cba52c5b1f9868f56b4e4825"
    sha256 big_sur:        "3e32fcd2f971f88a8dcac24702147ff5847afb329d9c54cadd40e9c102bcb3c5"
    sha256 arm64_linux:    "8153cdf87230c974c302e3c1c8de717bbc95344be3e28fd8293f6a680b95256a"
    sha256 x86_64_linux:   "1835ec7faed90c796e7290a5b6271dda1ac6b2bdb15ce577367852ad92681c39"
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-image",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
