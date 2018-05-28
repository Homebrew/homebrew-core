class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-197.tar.bz2"
  sha256 "aa82fb77ad415561bdc32f4f789b934dd251f4f6267be9ed62983668b7413c26"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "c771779e8d7017dfcfbc3cc40e96d2aa0a703bba18e0c19f52373aaa8bfdba52" => :high_sierra
    sha256 "133f30759d1d01b0d8c1a93db0d0c1da9af0b0e07bd426d549819b3566517f50" => :sierra
    sha256 "916f2f1be1a65b004d694717e28a39aec865d72d44d1d6e9c854364b79425e69" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
