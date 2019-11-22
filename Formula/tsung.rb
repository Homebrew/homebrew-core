class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage "http://tsung.erlang-projects.org/"
  url "http://tsung.erlang-projects.org/dist/tsung-1.7.0.tar.gz"
  sha256 "6394445860ef34faedf8c46da95a3cb206bc17301145bc920151107ffa2ce52a"
  head "https://github.com/processone/tsung.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5ba49316a6d401d171ddd27e366c9bfb1a73aaeced24b562a326dbe1bd1249ab" => :catalina
    sha256 "bfd02c24483727832c624e5de2e289efec4eaf30b651be8da85696c1c896c091" => :mojave
    sha256 "64dba403e11577b28f3a80114158b96d8c74f58d09a4d9930801674031d4a7d9" => :high_sierra
    sha256 "e52abdb35507ceff03804d29a1ecf4e64d11e3345a9f095462cb653bba6cac6d" => :sierra
    sha256 "11f06a010b1a56d7a751bf5379d7d053c1befdf41f73aabeb79330761566724d" => :el_capitan
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
