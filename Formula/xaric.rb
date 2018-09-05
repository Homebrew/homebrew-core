class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.7.tar.gz"
  sha256 "fd8cd677e2403e44ff525eac7c239cd8d64b7448aaf56a1272d1b0c53df1140c"

  bottle do
    rebuild 1
    sha256 "80e5230b07073263a0e38e537c823adda12735240c49e18d206b17cd1471cd4f" => :mojave
    sha256 "c9071a891ade585a6ce04f759ba8fa95ef786126071f1cd9f80863f1c295aed6" => :high_sierra
    sha256 "e3d4b5dd228aee7f9f81801e7696543983efb5df0239048adb035d984046f95d" => :sierra
    sha256 "9ddfb8878904f92a7281f5611a11b72b81ebed0ef6ac7af9c10588cb717b9317" => :el_capitan
    sha256 "f29d234ec8065f976ce8f14e21374871e5b8b2d092a26ad163d9cac32988bb9b" => :yosemite
    sha256 "3b8f2a6b837e43ff57ef626b4d46142562c1eda120ac5889124eab11d8b46b86" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Xaric #{version}/, shell_output("script -q /dev/null xaric -v"))
  end
end
