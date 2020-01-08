class Vbindiff < Formula
  desc "Visual Binary Diff"
  homepage "https://www.cjmweb.net/vbindiff/"
  url "https://www.cjmweb.net/vbindiff/vbindiff-3.0_beta5.tar.gz"
  sha256 "f04da97de993caf8b068dcb57f9de5a4e7e9641dc6c47f79b60b8138259133b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7e303922a1f33af5fe107d192a530cfb3d545a55d4b7e681cdb5603e24cdfb6" => :catalina
    sha256 "907ff3fce1fcb1cba6e746ea624f84234fe55703caa380b7ee19c1f8bb6cd193" => :mojave
    sha256 "c5d1025c94e7fe141a9522ed1460bfba8047393d63d59f54b391dec063c05c68" => :high_sierra
    sha256 "d6474b9e6a00c71f2c207c07dbfb015aa428d8f32e193b69c7b4a1f534f128db" => :sierra
    sha256 "b2f557094c03f5870173b32cdf9e8ff8bd7fd74340adfea7f1db6b6eced367d9" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vbindiff", "-L"
  end
end
