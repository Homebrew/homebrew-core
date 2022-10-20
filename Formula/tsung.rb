class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage "http://tsung.erlang-projects.org/"
  url "http://tsung.erlang-projects.org/dist/tsung-1.7.0.tar.gz"
  sha256 "6394445860ef34faedf8c46da95a3cb206bc17301145bc920151107ffa2ce52a"
  license "GPL-2.0"
  head "https://github.com/processone/tsung.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a9d329b07bf0f12e1cd44363b33aa8fdae0a583b51c7f17e21f779220a5045"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e48b00e815ae6bd028601423ce94a47d0ece9694fbb162808ff58f5d69e484f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8f5e4f5aaf60ddd4c8c4ac6c3fab88d6ac8bfbf8b0a443f388f758eae35cbb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "82f9c26269d705ce0757bb7b1f0485737b62bb6ab440c3a349a3910c2c929c31"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba49316a6d401d171ddd27e366c9bfb1a73aaeced24b562a326dbe1bd1249ab"
    sha256 cellar: :any_skip_relocation, mojave:         "bfd02c24483727832c624e5de2e289efec4eaf30b651be8da85696c1c896c091"
    sha256 cellar: :any_skip_relocation, high_sierra:    "64dba403e11577b28f3a80114158b96d8c74f58d09a4d9930801674031d4a7d9"
    sha256 cellar: :any_skip_relocation, sierra:         "e52abdb35507ceff03804d29a1ecf4e64d11e3345a9f095462cb653bba6cac6d"
    sha256 cellar: :any_skip_relocation, el_capitan:     "11f06a010b1a56d7a751bf5379d7d053c1befdf41f73aabeb79330761566724d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75795d52b25505bc8b1f5815d3b424fc2bbeb916e18e0d1f7e4f6ab5f605863d"
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
