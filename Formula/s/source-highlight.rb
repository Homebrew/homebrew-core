class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"
  license "GPL-3.0-or-later"
  revision 6

  livecheck do
    url :stable
    regex(/href=.*?source-highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "e05f56b94a75e09f12a5653c3b48a960a72efba4f4c449e8f00967208f271e93"
    sha256 arm64_sequoia: "8cc450abef52155d24d50527365267af448fa9ebc15d8843e779fb46f0be96a9"
    sha256 arm64_sonoma:  "e44e2d57c3193035e2e2a81bb5b1a4a58e9d390679679e200ed8226967d20b81"
    sha256 arm64_ventura: "7dcd24af23b31fc601b91e87309186ec0bbfdd6de9df721f25c6d3bf1589ba99"
    sha256 sonoma:        "72290398f59884c5ccfb7960219c3e15199bbacecad195f464c8750f7e448863"
    sha256 ventura:       "b004e32044ef67916ca8ef70324df7dcc5c01e777d76d17fcdb86e11a57595ee"
    sha256 arm64_linux:   "05ca474d2414b0531fc722d5ee5977c5f0d61f32785f47761d0a8056cbc712bc"
    sha256 x86_64_linux:  "09c0f664ede1dd50549c8cae4dd1a57b587c81da49a3f03b5d0b78e33f15a935"
  end

  depends_on "boost"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match "GNU Source-highlight #{version}", shell_output("#{bin}/source-highlight -V")
  end
end
