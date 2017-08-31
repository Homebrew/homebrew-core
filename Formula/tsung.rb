class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage "http://tsung.erlang-projects.org/"
  url "http://tsung.erlang-projects.org/dist/tsung-1.7.0.tar.gz"
  sha256 "6394445860ef34faedf8c46da95a3cb206bc17301145bc920151107ffa2ce52a"

  head "https://github.com/processone/tsung.git"

  bottle do
    sha256 "70b33befe9ef6fba1981a0297728e04582ade4f651569f2168d2b5f6fa82db49" => :sierra
    sha256 "88d485cf8a667207acb6e06415a0f065b747cef4f11d8b047944e40da308cb22" => :el_capitan
    sha256 "a4d0f870f04ae0683f4647123c5c3e94e39fd0bcf97edaa98dd2a4a4aa4dca33" => :yosemite
    sha256 "bea0124e4ec1626cd6f49a1cee650dedcd11602ca820a1764f2862e7b7341288" => :mavericks
    sha256 "1fe31187fd7662216c1a879bb62302a638834220e84becf8a1ab182df45c3d14" => :mountain_lion
  end

  depends_on "erlang"
  depends_on "gnuplot"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system bin/"tsung", "status"
  end
end
