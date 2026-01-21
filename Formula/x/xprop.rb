class Xprop < Formula
  desc "Property displayer for X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xprop"
  url "https://www.x.org/archive/individual/app/xprop-1.2.8.tar.xz"
  sha256 "d689e2adb7ef7b439f6469b51cda8a7daefc83243854c2a3b8f84d0f029d67ee"
  license "MIT-open-group"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16498c5be35fa49d3fb077e47270d30e791d045f9ad1a6ec52b5e375168b56aa"
    sha256 cellar: :any,                 arm64_sequoia: "cdec0acd7bb65c8b5c8817d838fdfa701a0320d87eeb34297641c87c91724bf7"
    sha256 cellar: :any,                 arm64_sonoma:  "9a8151c37776a1282ef79d084ea8243b5c99cd2da8c48621f989126b8e9ef204"
    sha256 cellar: :any,                 arm64_ventura: "7d3563c7d7f8e2956fd53176cde7778a1fc5e1a5faf740980c5edfcff200684a"
    sha256 cellar: :any,                 sonoma:        "1c66f81bd54f83a640e7f6e6a7ec95232f8d18715d7b9bf0b5c3b3b618b093f5"
    sha256 cellar: :any,                 ventura:       "1cdeb1e7acddc588e6d06bc905e546d8a6ce07a93f2b31b4a6c681b238e7eb5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9365e5e98c06c4d155393e2e152ed39a61dfde7a5c74c3b470e978fbcf7712c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14cddb19c4fd84f405036ecbdcf37e3d030840b3d21a81bff0ceec4da68a4a0a"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xprop -display :100 2>&1", 1)
    assert_match "xprop:  unable to open display", output
  end
end
