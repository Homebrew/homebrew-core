class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://gitlab.com/soundtouch/soundtouch/-/archive/2.1.2/soundtouch-2.1.2.tar.gz"
  sha256 "2826049e2f34efbc4c8a47d00c93649822b0c14e1f29f5569835704814590732"

  bottle do
    cellar :any
    sha256 "89d1037259a1c68865339b7dbdc837f22f397a33772d45c1296d9137ebc28a58" => :catalina
    sha256 "39081044f19ddcb8982560fb86e8c9b621c94e8bfc2de6eb4e398ba0fb2a2b9e" => :mojave
    sha256 "6d6651a6a7cc88c83279a49d2d676f8baf7731316f41dff3b0c77ac2d2fe7fb6" => :high_sierra
    sha256 "4b55c5ffffbba6f1c16f9a82860d3a0316b1d2bc478a6f7ac59e4cb36d70342a" => :sierra
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
