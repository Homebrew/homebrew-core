class Xeyes < Formula
  desc "Follow the mouse X demo using the X SHAPE extension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xeyes"
  url "https://www.x.org/archive/individual/app/xeyes-1.3.0.tar.xz"
  sha256 "0950c600bf33447e169a539ee6655ef9f36d6cebf2c1be67f7ab55dacb753023"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "819f815762f42fe4c83c16a8ab3b52374e86f5769012e7ad063b0f024348ebb0"
    sha256 cellar: :any,                 arm64_sonoma:  "e52653dc93b15317743e62242e8f034644dae383e6ceb60fa68fc6427e2e0ff1"
    sha256 cellar: :any,                 arm64_ventura: "897825d1a62e7e083aecb0c147dac2105d09ee2ffe6ae8d1474f13bd1db6f7ca"
    sha256 cellar: :any,                 sonoma:        "d3c0b81ec0978277c09cd13284835f8043e2dd3b26828f8979bdfdbbbff9f4b3"
    sha256 cellar: :any,                 ventura:       "aa8c90253dbc533b4be0e796644d3064bc06a661f0f6ec690111692e9c21b86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5feb5ba49b6ad60ff5291b15fbbd9f89eb9dc9210e87c42c83ee4c0c6b943323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "858c8dbe27ed47cc97b4a87877b97fa3268bcd138e2eeb7d509f8148404fcc85"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xeyes -display :100 2>&1", 1)
    assert_match "Error: Can't open display:", output
  end
end
