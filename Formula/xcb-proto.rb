class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.14.1.tar.xz"
  sha256 "f04add9a972ac334ea11d9d7eb4fc7f8883835da3e4859c9afa971efdf57fcc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b46e6d4bc878650fdf3a3e7b1ec9b9d9e80cf7d40d347d7ef8f9a244ff656fa1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b46e6d4bc878650fdf3a3e7b1ec9b9d9e80cf7d40d347d7ef8f9a244ff656fa1"
    sha256 cellar: :any_skip_relocation, catalina:      "b46e6d4bc878650fdf3a3e7b1ec9b9d9e80cf7d40d347d7ef8f9a244ff656fa1"
    sha256 cellar: :any_skip_relocation, mojave:        "24b88c1bf0f5ecc407136ed7139f0690167be335688c0c59990f2d393b6f75aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77acc7eceef3071a6ad89edf2856aaee324d0986491e3b4cd512741ddd6385b"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=python3
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
  end
end
