class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://www.surina.net/soundtouch/soundtouch-2.0.0.tar.gz"
  sha256 "d224f7d1421b5f8e74a74c85741345bd9802618a40ae30ce5b427a5705c89d25"

  bottle do
    cellar :any
    sha256 "9c847b734585151311bc3ac8190f43a697dd6aff403c26391eb990c2c9e347a6" => :mojave
    sha256 "5d980f6d661a942650e8b7953e5a0710d0be708421cdf595b68f7da917cdc2be" => :high_sierra
    sha256 "4861ccccd41fc57f2d553973ece79462e4c85897426f36c258b8fd1756416da1" => :sierra
    sha256 "7572fff0564f78a49641ed7c5eb9ed062ff557d452d4515e07544a622eaa17e6" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /SoundStretch v#{version} -/, shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
