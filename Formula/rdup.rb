class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  license "GPL-3.0"
  revision 2
  head "https://github.com/miekg/rdup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d46e7dd067e403544b2a287f92efe1d1ddcaa224f084e79f65878d4ef676a474"
    sha256 cellar: :any,                 big_sur:       "72d7f3ffd694f739534d795c9e317e025037482956f810b312b5e483d8907213"
    sha256 cellar: :any,                 catalina:      "cf02c3004b312a3d90c6e47227f35e39319736270be76d7e4b0705568a21abec"
    sha256 cellar: :any,                 mojave:        "fb091d60536b72e20dc5e1448d9876e7b2eaefd16d40f2bfbf7bba48059af348"
    sha256 cellar: :any,                 high_sierra:   "417244fe66e0f47ab1afea65e9a52db01c15ac2f5db5e150ad65d80b2e85e2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3b71f0f9c4a1d1879274bf2eb6f0244b3b06612128991a6c91e4bd39b56cc9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"
  depends_on "nettle"
  depends_on "pcre"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
