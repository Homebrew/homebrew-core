class Trader < Formula
  desc "Star Traders"
  homepage "https://www.zap.org.au/projects/trader/"
  url "https://ftp.zap.org.au/pub/trader/unix/trader-7.20.tar.xz"
  sha256 "bad368c471d7f4c371fbe8f5da24872f9e3ad609ddb7dad0e015c960c88b3aa9"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?trader[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:    "e1479fb417ef273bfa538ccd0427ff4721ddf9861e253f20886bb8924b85422f"
    sha256 arm64_sequoia:  "9be56b4808087e536b25a7728556b09a959e1f41fd17a512de2b911645fbbccf"
    sha256 arm64_sonoma:   "6ae36dfc033af6586d9b339653b74796de0bfca17e12e94a8ad74848ceef2b8c"
    sha256 arm64_ventura:  "38906420c79cc92198a4b560f8d4ab6862c8379b608cb833d0798c9b2cb2126e"
    sha256 arm64_monterey: "659237e8c041b9122c2792770c8e320ed6678782e214d2c65c2fb0febeb89427"
    sha256 sonoma:         "cf2f81124457ed2d2e149befd2a4ae5565b4bbbeee4489065f5728a7258e9c1d"
    sha256 ventura:        "eb2510848f86e058d2e71cece3b1c8907266da2b9a92b1e76161c45e180af9e8"
    sha256 monterey:       "89dec91679b5a775aa0d89ea0c9af16569b69dec9903b99998b9d7421564863c"
    sha256 arm64_linux:    "9c2b9f22360ef13d813e3b024cc74855e4e0cc4ef5933eda96f19f1961e793a7"
    sha256 x86_64_linux:   "39db68dcc4e59eb947e208f403ae5f1f3a8abbefe5b530339b2bd860768288b8"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "ncurses" # The system version does not work correctly

  def install
    args = %W[
      --disable-silent-rules
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Star Traders is an interactive game, so the only option for testing
    # is to run something like "trader --version"
    system bin/"trader", "--version"
  end
end
