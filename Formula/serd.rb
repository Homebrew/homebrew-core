class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.30.4.tar.bz2"
  sha256 "0c95616a6587bee5e728e026190f4acd5ab6e2400e8890d5c2a93031eab01999"
  license "ISC"

  bottle do
    cellar :any
    sha256 "3361f452fbde6a02d8dfe77fdd53c6c5ff99e0bcb9df4504526674641cc4b24e" => :catalina
    sha256 "e511ee4c7bb634cef312c139535c537aaafd70bbf2c62900a2b2950901f9eebf" => :mojave
    sha256 "6d5a775d35f00fca2fb98c9177616322e3a868204c2c3f93614102e5ece3237f" => :high_sierra
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    pipe_output("serdi -", "() a <http://example.org/List> .", 0)
  end
end
