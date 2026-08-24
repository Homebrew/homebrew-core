class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.15.1.0.tar.gz"
  sha256 "eab9c46e22b66b16135f9a05ec68a0ea287d9060b84d10defaaa2caad158ab52"
  license "ISC"
  head "git://git.skarnet.org/s6.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "97d2b9ae8f7d72200101a733e5fcc6ae540e041a99e6f1c53633f06c49c1428b"
    sha256 arm64_sequoia: "ee0027a9b6666d5615a632a1a7a4be55e169285c96685455ae1ccafb295a27e8"
    sha256 arm64_sonoma:  "d85f1551fa98060027da074465b4ca03c34d1982d5abdaa2a1c2b22e332ecfe9"
    sha256 sonoma:        "8f67b42f8db8c7006675f5b43770e6c65a9dc5dadcf97439a93463820e5bf8e1"
    sha256 arm64_linux:   "99944f685caaf9d66de610868d3e89f482d1d1e0933c3159c226f3955ae471b6"
    sha256 x86_64_linux:  "4cc6bc1a649dbb242f1fdb65462a1051b6dc7dede4d56eb7119f9b2d3bbb9910"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
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
