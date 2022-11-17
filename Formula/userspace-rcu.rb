class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.13.2.tar.bz2"
  sha256 "1213fd9f1b0b74da7de2bb74335b76098db9738fec5d3cdc07c0c524f34fc032"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "662b6c7315f6070482140ddd035874cf52c434286d44a44bf7f31125ff7686ae"
    sha256 cellar: :any,                 arm64_monterey: "d2cb9246e240a6db9c40d9e3a19288d064ef95345f3e884a5892fa2b341fcb9c"
    sha256 cellar: :any,                 arm64_big_sur:  "c661f7dadf4ef5fdedc1ea707da817fba3e491b0b263b070fc234f35614a8afe"
    sha256 cellar: :any,                 ventura:        "ebe06cf034c8018f1c1ff1420a11a29df85f4a5a2e7852466e43944a83f82877"
    sha256 cellar: :any,                 monterey:       "c9cf73dd281dddd9fca16844e005392d0f0fb1132f4540ef95e552d7799113c6"
    sha256 cellar: :any,                 big_sur:        "5e1b5b33fc0f5ad814ddc1d738f5ca8c2811422b9d37ecc1d517328287fc7d4e"
    sha256 cellar: :any,                 catalina:       "3056888d7a39aa8ff2859eaac9d14ed0d15b921d857378160f6f49f7365ab07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35bfb4f4d8c549bcc9a75aaa5e194c410ad3134768b8355ff428a82ec905a0dd"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", "CFLAGS=-pthread", "-C", "examples"
  end
end
