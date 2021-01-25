class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.12.1.tar.bz2"
  sha256 "bbfaead0345642b97e0de90f889dfbab4b2643a6a5e5c6bb59cd0d26fc0bcd0e"

  livecheck do
    url "https://www.lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "16786f80939cc886441f4be7850c1ffc3cad092aaedcfb9a5d3f4bc08aa17edf" => :big_sur
    sha256 "8d45763c520497f2a3062f4d4c7c9a291c956462e79fad11fc2f6bafc63ede75" => :arm64_big_sur
    sha256 "87815b2af972d7e3596e639cec95b6da61436108dcb7380629c5f5b56785d513" => :catalina
    sha256 "a5fc1494e06f10ab0aa2743dea422d94206248cc72ea504cc48dd0fb1837c780" => :mojave
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
    system "make", "-C", "examples"
  end
end
