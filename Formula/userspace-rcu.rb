class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.13.1.tar.bz2"
  sha256 "3213f33d2b8f710eb920eb1abb279ec04bf8ae6361f44f2513c28c20d3363083"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4c2e92d6a1b70701ab105521bfb3553b1b29fe8a0af3944c27e882de6ebc333b"
    sha256 cellar: :any,                 arm64_big_sur:  "d952a93e176b6c2b14a3d44ec93070be05b1e083266b7fbd406725178ac2727d"
    sha256 cellar: :any,                 monterey:       "fffd32590e244100ac004f06d88453e00351bae217b80e8a6954a3c4d3be6f02"
    sha256 cellar: :any,                 big_sur:        "345b0ee7a81bd7c4d288c76a710d05a2a579b4167a6dd69c489de531d3b71502"
    sha256 cellar: :any,                 catalina:       "cdc54b4a7f20eb89dd2674ada6664633c0ac1e760e55eeaff553c16326cb8160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1423e05dc0e6d8465145ab78d43cd09feb91fdd3a0d69703753750d42e63dcc1"
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
