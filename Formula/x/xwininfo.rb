class Xwininfo < Formula
  desc "Print information about windows on an X server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xwininfo"
  url "https://www.x.org/archive/individual/app/xwininfo-1.1.6.tar.xz"
  sha256 "3518897c17448df9ba99ad6d9bb1ca0f17bc0ed7c0fd61281b34ceed29a9253f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96d34d4f1087c1eafa6c74937b5b0df87ee49e80762ed24023e89e0c78878931"
    sha256 cellar: :any,                 arm64_sequoia: "de81136f2da87e8553dbabd1ef911279447842a5d9a03cdf9b05830ed464fca0"
    sha256 cellar: :any,                 arm64_sonoma:  "c990cacb2c672ffeef97ce1e9e6bf07a62de68b31e0c844a374c6ea4330caddc"
    sha256 cellar: :any,                 arm64_ventura: "16c77dd94be1ff317276e082156a1e9d28456e832c30aa41c0320ea320d51e85"
    sha256 cellar: :any,                 sonoma:        "1d472ba18ecda4f5179eb264dd065876d1db5671c7b400302394e2014e70105a"
    sha256 cellar: :any,                 ventura:       "5573df075228169227184182f804a0991056d0e517c5cba11916554b1bf44f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "145243b1c9fcf322bbd5815d6dd2a968d3332d3281ef899fbf385aadb92dc1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eec07b0f162130654bb10cfa0911bd34c3e7f32a92b35454a1ffbf70a41c0d1"
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
