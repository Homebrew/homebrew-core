class Xdpyinfo < Formula
  desc "X.Org: Utility for displaying information about an X server"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/app/xdpyinfo-1.3.2.tar.bz2"
  sha256 "30238ed915619e06ceb41721e5f747d67320555cc38d459e954839c189ccaf51"
  license "MIT"

  bottle do
    cellar :any
    sha256 "d0bfd330052a61271d604640de4f6e44b277a41ab8eec0cc9b6c5a75e649002a" => :catalina
    sha256 "b14c61c161037be3f2913d6a7ffcdc3bc415f244718d813608c866602d9fd198" => :mojave
    sha256 "6e069524d654b3f89ec300b5516b12360e2f713786f01a2597e7210c18b69dcf" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxtst"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match("xdpyinfo #{version}", shell_output("DISPLAY= xdpyinfo -version 2>&1"))
  end
end
