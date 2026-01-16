class Xorgrgb < Formula
  desc "X.Org: color names database"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/app/rgb-1.1.1.tar.gz"
  sha256 "9bceca0821a46ff54989ab08ab00d6dd87eb2779fc15165d848eaa0ddd742fbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "159d5fec59b9e636d32f19ea34afbede62f66570ccdf032640bcec65bab8dd8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35bf31cee3ecc5346e8e702941b781afeb6ac9e3e41723094a47ab4863429fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f3467d30599e1855fc62b23db5b4dbe709b593c90b9fef775ea86141bd6c05d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7638605023153225dc39fb4322ef00ec039531ca1ba13f12ff26f2dbf8b17d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "625580b1d2ca0c33fa1aaea94a23cf29945e8d9a9de97286ea728369b5a8ff6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3a5e626941b7b150c0e39f5101b8320d637f20ac0f03f6532d7f671aa2f001"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "gray100", shell_output("#{bin}/showrgb").chomp
  end
end
