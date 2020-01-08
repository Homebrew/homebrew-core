class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq715.zip"
  version "7.15"
  sha256 "e85ec2529eb0ba22ceaeabd461e55357ef099b80f61c14f377b429ea3d49d418"
  head "https://github.com/zpaq/zpaq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "091d81c8f85afc293897a500209dcf1949cf14c7620c6fc3e1c6b226cba26f08" => :catalina
    sha256 "bf0cfe4bbed251ea8a8503e310df77fe38d7da0180394e1e0deb313841ba48d2" => :mojave
    sha256 "d6f9b354e10afef1ac343485074ec8c3a1379163aa1c57ed91813832b23572ef" => :high_sierra
    sha256 "63f132c8cbff5b22daddc07289837ad710c4af7785fa36351a498cc99e77c6ec" => :sierra
    sha256 "beafa9e6d0ba28368a77d9ddcbaf3b04a3f02716f08eb4b2a345745c45fcf9d2" => :el_capitan
    sha256 "de09d5f93f86f77372ea01b40f23481bc3e6cd33b9b2ac67736c85167a760dbb" => :yosemite
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "b110688939477bbe62263faff1ce488872c68c0352aa8e55779346f1bd1ed07e"
  end

  def install
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testpath.install resource("test")
    assert_match "all OK", shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
