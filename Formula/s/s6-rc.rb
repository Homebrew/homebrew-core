class S6Rc < Formula
  desc "Process supervision suite"
  homepage "https://skarnet.org/software/s6-rc/"
  url "https://skarnet.org/software/s6-rc/s6-rc-0.8.0.2.tar.gz"
  sha256 "2fc0fcfe1e74b404b132a978eb316668c8bcdbc1104b3b0fe702a3d2d76caef5"
  license "ISC"
  head "git://git.skarnet.org/s6-rc.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "6c4298ada36a6658090c900fcb6598732a707925aa9de244bf035fb23ae5efad"
    sha256 arm64_tahoe:       "6cd387ca2a7d859c9cd2b63ba8beca1e3df02f6cd9365c990035fb6edff71267"
    sha256 arm64_sequoia:     "f44e1d58420361aba18f5796f8b5bcb480b6fec077ee3820d0354ee2927380f3"
    sha256 arm64_linux:       "ab53ad811308905a7f08935751886aa2bd36360df2f23f7d896b344426bab87f"
    sha256 x86_64_linux:      "da9b1cbfdb105a5270b979892bfb1a1591dd8ac5ad60ab7738f0cf329bad9109"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "s6"
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"services/test").mkpath
    (testpath/"services/test/up").write <<~SHELL
      #!/bin/sh
      echo "test"
    SHELL
    (testpath/"services/test/type").write "oneshot"
    (testpath/"services/bundle/contents.d").mkpath
    (testpath/"services/bundle/type").write "bundle"
    touch testpath/"services/bundle/contents.d/test"
    system bin/"s6-rc-compile", testpath/"compiled", testpath/"services"
  end
end
