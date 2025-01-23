class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage "http://tsung.erlang-projects.org/"
  url "http://tsung.erlang-projects.org/dist/tsung-1.8.0.tar.gz"
  sha256 "91e8643026017e3d0088a6710fb11c4f617477e826ebe4c5fe586aa63147fc92"
  license "GPL-2.0-or-later"
  head "https://github.com/processone/tsung.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f3513c9c20699e5a307bbc22ca89e15c4d476508ff4df5ef55c79357895fdf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1ebb56a584c6b3262d5e3e0d7727ccb2a51de2e20ad6e01220e893135495f79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa20dc7737ea74dead418707ec87790f3117b8627b66251d269740ba25a7c991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0d6b63d452e76063467aaddc742adafe94d3817167de0bf074ad23d13fc6462"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccb835f8fb42ced8459d64c5a55ad41e64548a3f5574c707aca1fa1c16a8b41b"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a7a97f566daf05b32b3252902d6499412d91491da5f4874c3deafdd9979e1d"
    sha256 cellar: :any_skip_relocation, monterey:       "3323a1469f410ad82f9d49aedaece4f8681f7bfb1ea59ff578037dcf9fcf9691"
    sha256 cellar: :any_skip_relocation, big_sur:        "a914e38136188ac75999578185d1b842f1f72f657556c2a0e467ebe2b164f5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "318abd3a1719a810eff7133506bb49a2088c180f0c5bd149db7124c386687824"
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
