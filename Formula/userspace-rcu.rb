class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.12.1.tar.bz2"
  sha256 "bbfaead0345642b97e0de90f889dfbab4b2643a6a5e5c6bb59cd0d26fc0bcd0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "02f81d6684238e1b546a4d5fad616da478171f6625f7ee02e85aeacffbb7d4a2" => :catalina
    sha256 "17358f51aecb1becee1b8b47fe7d10eedc5d54cd3d7c1356bc958f91d945d0d3" => :mojave
    sha256 "0ce56f4cf3f7793709889442a64276933d6d464471838fdac1277a48ef5f0f0e" => :high_sierra
  end

  def install
    # Enforce --build to work around broken upstream detection
    # https://bugs.lttng.org/issues/578#note-1
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --build=x86_64
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", "-C", "examples"
  end
end
