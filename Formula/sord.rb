class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.16.0.tar.bz2"
  sha256 "9d3cb2c9966e93f537f37377171f162023cea6784ca069699be4a7770c8a035a"

  bottle do
    cellar :any
    sha256 "79ac2ab52531da8fbf650a4415907e6098e5038fea13c8a00db4efb0b6e343cc" => :sierra
    sha256 "1d2d04b071394a4b7381f89812ecc05f6967b87936935131d077c95f13b9a2f2" => :el_capitan
    sha256 "b4c0d5559e0c1aae7e8de803e75cdf84858f67bad70ba663979efc29c07b081f" => :yosemite
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
