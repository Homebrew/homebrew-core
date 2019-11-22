class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-220.tar.bz2"
  sha256 "cd67521937e65800fd981cdfd5454cdc3df799586e0198bb212142ace10f4f02"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1e524a37fed96ea743e315b71a087aa777c27150b9176de00749a91a1ab0d1f4" => :catalina
    sha256 "7951f53389d09a07248fff9ec2a388efa4cc61a9d6b3a976d5df15dd6114de8a" => :mojave
    sha256 "81824c3ba4c8da89b9f95eb233a297ab8ba650373f00107624c8bac57b086689" => :high_sierra
    sha256 "dc143712f1109bf6e08c0b949a55b201b9ec9610952a4e139edcbeab15c5ce67" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
