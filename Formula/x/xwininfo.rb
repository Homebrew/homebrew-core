class Xwininfo < Formula
  desc "Print information about windows on an X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwininfo"
  url "https://xorg.freedesktop.org/archive/individual/app/xwininfo-1.1.7.tar.xz"
  sha256 "bee14d594cc86cc59aae1015c1b452a71bf60c304131e2716ca1cf0df733b4ac"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "30ecba9a7aab38f96ee651c7dce3a36ce5c1c5ef95230f2605033011681b6df8"
    sha256 cellar: :any, arm64_sequoia: "f7c9008f5ecd9f185b8cdab3e16632d6fee865eb5cbe75349e2dc5678182bc87"
    sha256 cellar: :any, arm64_sonoma:  "60394d6aa87198d8da6e2d6caedf881198b54b7f8eb5310f36c3a04acbb3c6b3"
    sha256 cellar: :any, sonoma:        "835c106a7f39313570ced36067323ecbf7fb2b1fae1e5c12d23fbf26019ce35a"
    sha256 cellar: :any, arm64_linux:   "5be03ddf54cb855a15dcd654f4a61616ce3bd45942b79a115b940d82fc21a0cb"
    sha256 cellar: :any, x86_64_linux:  "a1c62f812fec8653a4f43f4f1f4d10037c66723264b1d1abcea48da13cf05729"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxcb"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xwininfo -display :100 2>&1", 1)
    assert_match "xwininfo: error: unable to open display", output
  end
end
