class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.30.2.tar.bz2"
  sha256 "9d3102701172804f823f2215ca3147c50eba992641f9fbe014272355f4937202"

  bottle do
    cellar :any
    sha256 "65513a53267446e3961469cb568fac89cf3e7c2a95bc15d746f1c4c02ed3b0ad" => :catalina
    sha256 "bd9e7ce8907a1666e96d81f86002acde4aef03a7b8546370b6116ea233c2624c" => :mojave
    sha256 "660553dc88a3855c6d62f323297a2d383ad5493ba859a41779a4d799159a23b7" => :high_sierra
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
