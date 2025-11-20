class Xdpyinfo < Formula
  desc "X.Org: Utility for displaying information about an X server"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/app/xdpyinfo-1.4.0.tar.xz"
  sha256 "dc1de6e6e091ed46c4837b0ae9811e8182f7be0d2af638cab3e530ff081a48b6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fcb8183733daa8e2ef8e35810c377ff385422aca8b10d37d0c85adcf99c2f2f"
    sha256 cellar: :any,                 arm64_sequoia: "79e093122b8553c8317273bdf277575d67e0293d9c483d3f87fca8b0abe53974"
    sha256 cellar: :any,                 arm64_sonoma:  "357e14ef300086891542206e948319a56440f052d4068ea1a886735745086e0d"
    sha256 cellar: :any,                 arm64_ventura: "b36050b820cbc15b83fbbb34b59a3bca787f66acc1a8b2d9b14cd3cef0411379"
    sha256 cellar: :any,                 sonoma:        "7158d0c65b17a0b8aeb992070734e5739d1c9790d176a34a873cdb441aa60fad"
    sha256 cellar: :any,                 ventura:       "bfe63004977cd29e1da8b180ae2ef3542f60b5efb7ac208eda3840b48af8d30a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29ec68f0bb272eb3e7da43584532558306edf67e933c19dc0dcc534226b17ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38be82e4609b9b2900c19ad01c9fa0353b8ef6e477eb93a0e113eaec2ead5141"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxtst"

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
    # xdpyinfo:  unable to open display "".
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match("xdpyinfo #{version}", shell_output("DISPLAY= xdpyinfo -version"))
  end
end
