class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.12/recode-3.7.12.tar.gz"
  sha256 "4db1c9076f04dbaa159726f5000847e5e5a83aec8e5c64f8ca04383f6cda12d5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ca950e0f4e50459a5aa6800dc411c1ccde64865cac4e740de65a5019639d822b"
    sha256 cellar: :any,                 arm64_big_sur:  "69206a0503a2d1780ff9ccc8eaebf6adf94b4018bb0efb4cd983f7f5a3d07ce6"
    sha256 cellar: :any,                 monterey:       "76bf51e5a583a21bad1f24ea1b4c5ce568974a732c99861d1fa0a31213146e81"
    sha256 cellar: :any,                 big_sur:        "020a78f27f0275d0fc8c0621ea5b21a6f6ef6ff8279fdcafa401f316cb078c01"
    sha256 cellar: :any,                 catalina:       "f57a3d106020c93f0ba9e713cddbf50dfc5a1e86efe25dce36060ee16cd0eeb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "365bd66e439e5592ee482547354c758279ed085413efd9eb926db2beddb3d32e"
  end

  depends_on "libtool" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
