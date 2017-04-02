class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20161204.tar.gz"
  sha256 "0c9d8a593765a6d1074690de987c6ffd5753406c9d1e527e20c0289bde0db764"

  bottle do
    cellar :any
    sha256 "58289c28ba4c48e998dbd34057d469316157c4048c3eb16b5491b560023d821f" => :sierra
    sha256 "b8ef6c25ca731678e480863989a7a200eb0d9ce816ff8822336d431de0856767" => :el_capitan
    sha256 "cc351ebebeba134b4adf93b45503628052e7aa9e8bcd6f4c9b45a5530379b2a1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
