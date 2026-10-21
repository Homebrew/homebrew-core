class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.15.1.1.tar.gz"
  sha256 "62080839eb5b04d51efd4ef6e7b43e29b5d0576efce9eb319ace32ea90c05931"
  license "ISC"
  head "git://git.skarnet.org/s6.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "13bc68dfa69cb632018545548b37673c0bc62b2d752e7f5be34e8d19e941a40e"
    sha256 arm64_tahoe:       "d1055a78aee3f206636908c44fa1efdcbcb4b78395e497bd79f670ed51f60cd2"
    sha256 arm64_sequoia:     "7fd232a6caacca72eb022646b320008142b9ad6288ee8066f8e81be14daca55d"
    sha256 arm64_linux:       "9587a52cab4f67a1767c323a28c617bece2a8a1c9f5d33c23b1aa7c8d9fbf986"
    sha256 x86_64_linux:      "5b62644f6c3154611b309fc0e358a258054f68267d265c81658b0d9b94fda5dd"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
