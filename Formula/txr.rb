class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-190.tar.bz2"
  sha256 "1a03b1d4079e779d51c769f97d648f257a690cc200675ee3434b2d8975351992"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "527a31d473403e21eae3b400f764cad6cd44ffb8369816e72588426761596bd6" => :high_sierra
    sha256 "e2f1b6eff9d5b55795629ef8a7f7f4770ea795a0f9f721b5b057542ce718f4ae" => :sierra
    sha256 "056370775af0477df6a94669e91590bb800179b3832dd1e905388987a9b87319" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
