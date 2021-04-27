class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.14.1.tar.xz"
  sha256 "f04add9a972ac334ea11d9d7eb4fc7f8883835da3e4859c9afa971efdf57fcc3"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ab62d4a00b0901a5676a904d9d58e263a2c6220d6bb08ea8bcee72ccede7b7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4059bed377fd405eb7d2da7a550d2cc1fe33facfa2d2b0c1f3b4b8ebb40c70e2"
    sha256 cellar: :any_skip_relocation, catalina:      "2cb7d82e47a13c5e90f1fb8e90eccd596efa140f13d3c34bdf594f2eb07adff4"
    sha256 cellar: :any_skip_relocation, mojave:        "f1bb7552c78b5f0d5adb7085e509c7ecaa6da5afd3bfa865546778e0dcd9a5a8"
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
