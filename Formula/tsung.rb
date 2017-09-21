class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage "http://tsung.erlang-projects.org/"
  url "http://tsung.erlang-projects.org/dist/tsung-1.7.0.tar.gz"
  sha256 "6394445860ef34faedf8c46da95a3cb206bc17301145bc920151107ffa2ce52a"

  head "https://github.com/processone/tsung.git"

  bottle do
    sha256 "6a5f134428985b83e21260b6c95d71469d782705709913b4eadeb867e2213e34" => :high_sierra
    sha256 "aa42236bbee2669782a403e2ae494b48fb97e2155cdd6d3bd60728719c1f1265" => :sierra
    sha256 "9febf50b525e5c631f5bc5219d105f781668963644b4765bd0ef4098ed939b47" => :el_capitan
    sha256 "0b12c238f39d105daf49018f31e2b5fda548890a93b5f5c5c840dd140c18b23b" => :yosemite
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
