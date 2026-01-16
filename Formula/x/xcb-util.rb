class XcbUtil < Formula
  desc "Additional extensions to the XCB library"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-0.4.1.tar.xz"
  sha256 "5abe3bbbd8e54f0fa3ec945291b7e8fa8cfd3cccc43718f8758430f94126e512"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "325a22ce66ff9fd565932b080bdb02e5bdbafd6240e5664fb8a22c1ee87b29ff"
    sha256 cellar: :any,                 arm64_sequoia:  "f23b606bbe08c4b9fc5ce87f19db91cec6fc152298157af1632cb109f669a83b"
    sha256 cellar: :any,                 arm64_sonoma:   "f29e26409668f49cdebd9f07f926deb60775d4d937ad688ea1676b138e2ac3ec"
    sha256 cellar: :any,                 arm64_ventura:  "9ccd3441ee24d90d2f4d8d62cf74d6d8bb0879b60d7b56b325b72ae0854459ee"
    sha256 cellar: :any,                 arm64_monterey: "215d383f16158649c221e28f4c4d3c1ceac50c38ec36acad63dcb95a8ae76373"
    sha256 cellar: :any,                 arm64_big_sur:  "8052d4df2e15613046722b788d9e4665a9886974e9fc4cc20a6c740ff8e2d08f"
    sha256 cellar: :any,                 sonoma:         "d51d1ab192eeb49eb7a333fdf1b34b20a5f35059b0436d2d664683a732ae3776"
    sha256 cellar: :any,                 ventura:        "d075d423178430bc500bf16be08e20b20a06ae6a24ba581cd105a3b078af6d18"
    sha256 cellar: :any,                 monterey:       "57035a7c42a40246ea3d5ac12906e2832a4ea0aded7000b977a9d6b581e8b5b0"
    sha256 cellar: :any,                 big_sur:        "f42650c534ec07d5c17e612ae9f738c46ddf9fba07623eacbf28865a93eb65df"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e9f845b0c76c96c28ae201d82574694cd56ce41f3b4244a4ca6cb369b5c43d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2808f955e6ac8cb3d1262e4a01b589c5148b125eec6c57a6ccf02902cf01b182"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libxcb"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-util").chomp
  end
end
