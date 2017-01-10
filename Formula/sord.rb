class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.16.0.tar.bz2"
  sha256 "9d3cb2c9966e93f537f37377171f162023cea6784ca069699be4a7770c8a035a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "450cf1c1bd1440776e63d288ab9feedfdaa572e717258355e8fcbd523e944067" => :sierra
    sha256 "1f03c341d2ff39082e12ca7ef48b7c599cbfa57c1064f3117997dc3641bf29eb" => :el_capitan
    sha256 "dfa53d9dae13b29a164710351e772e3518e3821c1b83b52bcd5c1e76e7471786" => :yosemite
    sha256 "cb2ca5b304181e590334ad9cfec8b2dbce606b385a39297f7dd31aebbb9d7c39" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
