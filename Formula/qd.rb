class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://www.davidhbailey.com/dhbsoftware/"
  url "https://www.davidhbailey.com/dhbsoftware/qd-2.3.23.tar.gz"
  sha256 "b3eaf41ce413ec08f348ee73e606bd3ff9203e411c377c3c0467f89acf69ee26"

  livecheck do
    url :homepage
    regex(/href=.*?qd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "643d12788d9d0aae84284d8323dd768897ba709fc576f0d3344741f425082a32"
    sha256 cellar: :any,                 big_sur:       "9d11d1a792bcd856fffed2a3266093113e5099e4b4f36ee8581bce5b7a36c78f"
    sha256 cellar: :any,                 catalina:      "b7193beb4f8d9737d8f83b4d41c8703bfbf1ede0269630a783138fb3dec8b6a0"
    sha256 cellar: :any,                 mojave:        "8a70f3bc3a2fc99bef85acf2c567cd3dc1013f7046c19c7ffa0ddc266df231df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "684f25257cfa7d3110c34652442759542ea8623333e30aab8e1426d9ef7c6bd5"
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
