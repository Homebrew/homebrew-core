class Xorgrgb < Formula
  desc "X.Org: color names database"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/app/rgb-1.0.6.tar.bz2"
  sha256 "bbca7c6aa59939b9f6a0fb9fff15dfd62176420ffd4ae30c8d92a6a125fbe6b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1498d717e15491172bda9366e1c51d4ca706c5871e4157eb5928b0ac2e4b041"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8ca2a46987f85cf4fe5c06c808d462ed7fd6cbade4ab9a459825553cad8ccdb"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a1e5a984ee4505fd2c9a47ff716c88b9e24be35b98b674d19302df1934efb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6756bd8981d3006fe25f524bc8220f07d1a5995e77eeb3ae31c3d8854b98678"
    sha256 cellar: :any_skip_relocation, catalina:       "ec1075868cfedeed6e68f844637fe8cbf1d978cacb6bedf6ca746a3a2a5e68f8"
    sha256 cellar: :any_skip_relocation, mojave:         "ab75e74585e880cdaa2a0383626440834dcf2ed164d8c556d12ca9e74ede9386"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9035c5f64f471dcf32ab07e2321237fcab8a5fc3057cef3f29664db32222fc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f3380f8e66bbe354b1984f279211c9f1ef06e8e5e566c27c90d85f4af0ef06"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "gray100", shell_output("#{bin}/showrgb").chomp
  end
end
