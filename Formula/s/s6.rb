class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.14.0.0.tar.gz"
  sha256 "586bf8474d852655b89f1144c3d95461a1cee77f016dae6e75a3328b8a2f5df6"
  license "ISC"
  head "git://git.skarnet.org/s6.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f01e573fba1d56838e827b5455224a5299dbdd85e6cdb81931c4a265a473db6"
    sha256 cellar: :any,                 arm64_sequoia: "d4488f63b96ff55559e825d9367eb6a174ef6d12d79496f050dd4da767ca9b95"
    sha256 cellar: :any,                 arm64_sonoma:  "a8f691cfaf659a1d72d93d1c582b56d012bdc5636b92796154a2d3877094bd30"
    sha256 cellar: :any,                 sonoma:        "869a6c7000da29a7937bec581fd30a498d4a3a0846112f574221f025094941e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8d3fbd546539676b8da20c4ae7132d84e4ba82e3ee3aa34abdfd517a752c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd5dad76f3ee1558fc06357a606134321b76030ecf9c126d3742b5062c91a25"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
