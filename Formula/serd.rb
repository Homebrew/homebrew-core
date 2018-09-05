class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd/"
  url "https://download.drobilla.net/serd-0.28.0.tar.bz2"
  sha256 "1df21a8874d256a9f3d51a18b8c6e2539e8092b62cc2674b110307e93f898aec"

  bottle do
    cellar :any
    sha256 "f93b549178bcccb52cc2cc939f25f772ad1c5d05c521ff4c277baae360ddb4a6" => :mojave
    sha256 "0c55076d7655da6d7d5154e24cd3d720fd9afcd610f5e7e9ee5af23859ab85f7" => :high_sierra
    sha256 "7c7c1f9317f0fd595bfcdb8214e510c10648f99cdf9be1464b272abd4fa223ea" => :sierra
    sha256 "8c0c40af6e4aaa222c37cd154d2ef80c6b13a50744d97e94139250a5e1a778a0" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
