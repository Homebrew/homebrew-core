class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.1.tar.bz2"
  sha256 "98d66cc12f2c5881879b976f0c55d10d311401513be254e3bd28cf3811fb50c8"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73162f8ca4046c86b0586c58ece0d22d13eaa231634eb2674b5d695ae39c5b02"
    sha256 cellar: :any,                 arm64_sonoma:  "5fe51b86da5faf4f3707e2faf929f26d519d1f20dddcd37c650e98e2d9314294"
    sha256 cellar: :any,                 arm64_ventura: "382b08ef29134ccfe9f7602277174166c4efec6aa9a0250758f5a586043b6513"
    sha256 cellar: :any,                 sonoma:        "98db909a5f8d435a97f719f591aed551ff339ce0dbed53016b42196361914da9"
    sha256 cellar: :any,                 ventura:       "e078d7b289f0dde96dd60f6397146b3e67b076d8843267c5812e09592889947d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aca902724285d0fce858f8e0253b15606c22e1cb648ebe5d608babf52ce0344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e6918916e2c888dbd677a33429f01ec181c1fe965a729c0d471f2957bcb5c3"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["disable-debug"] }
    system "make", "install"
  end

  test do
    cp_r doc/"examples", testpath
    system "make", "CFLAGS=-pthread", "-C", "examples"
  end
end
