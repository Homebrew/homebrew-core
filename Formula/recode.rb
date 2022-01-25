class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.11/recode-3.7.11.tar.gz"
  sha256 "97267a0e6ee3d859b7f4d1593282900dbc798151b70a6d1f73718880563b485e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4454dfe3bb59d161c26ad45a414e55ecaa978f8dbdf5da50c2532cf8c133ea03"
    sha256 cellar: :any,                 arm64_big_sur:  "b6a98034312d20bb4b98a01142955a58f45b6c6c16423a6c7803623ecafb561d"
    sha256 cellar: :any,                 monterey:       "cda08cc34328044a50f273964d1df6a0d9b56b53d92a5a9e0b25c6cb8d0cb326"
    sha256 cellar: :any,                 big_sur:        "4f789898540cc6f8881266b550c3fbd1e71b8bb1aeffaaf0f92297c578197f7f"
    sha256 cellar: :any,                 catalina:       "59557105bcd001c631beefa18998a16141080247b9c4f47de0b2fca998405513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe064c49b58fffe04d0809088fb8c4a823936b03e490704780bb5da543e5b2c7"
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
