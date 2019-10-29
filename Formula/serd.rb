class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.30.2.tar.bz2"
  sha256 "9d3102701172804f823f2215ca3147c50eba992641f9fbe014272355f4937202"

  bottle do
    cellar :any
    sha256 "14de362fe3bb578ece49d17a7c1e75d477b7cdc64b4a99d2975c05a9afad1ea4" => :catalina
    sha256 "782e370f3ee5718fa706744b5a2c7185c9d1e1216c0b6c11c34ef10c489af8ad" => :mojave
    sha256 "34a847ef82d478c6f60ad532e43ae8601758242be46aed85485d2cf2e6c20b6d" => :high_sierra
    sha256 "6daae3f4fe65b0fae94f309d8538a40bdca5b207d2e464b47badcacd5408bb7a" => :sierra
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
