class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "http://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-188.tar.bz2"
  sha256 "4fd3ce7bc91ad9e27c664e26f0a1d291ba6d559b00f92d12ad07918be4814c36"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "f3d8c53ee19122be12ec5bf0dc647892f9f866f0c8a9541285088f2d3ebbc687" => :high_sierra
    sha256 "c4101b0a92f46112db3f5014895ebb3222fa15c6b3392121c12c95a07246de04" => :sierra
    sha256 "f665596eaae80aeb94db5320feb3467a6be0b0f1aca7ab320334e3c6b9f19894" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
