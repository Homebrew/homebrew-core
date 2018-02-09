class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-189.tar.bz2"
  sha256 "1e6ec696332ea150f05ad61145c180134daa7c85cef265e5d4f350e90267cebe"
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
