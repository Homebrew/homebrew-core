class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.5.tar.xz"
  sha256 "a4000e2f441facebf569026bedecc23ba262cc6927be52070abe0002625cfbe0"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c41ec4cab2cf6579ed12863a167d2c8cd5d9ee442f75e59687c616094960a6cc"
    sha256 cellar: :any,                 arm64_sequoia: "7c1cda56269b3c051bdad31e681565c66e58c2dcbcb029381de38dfbb353353d"
    sha256 cellar: :any,                 arm64_sonoma:  "982b0370134b594c6c98433bc73c4e3efda11525e729c1b91fd388a71b85ca7e"
    sha256 cellar: :any,                 sonoma:        "cead5271fac2eb731921d8e90ba19568d94c7dfe90f3401619e557e5481af528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecad1dc56975cdab489d246cf7fe25ae04a08298e4482195dbc5ddd91783d3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2c4255c039ae81f80704d6965f1ab02ad51877e8ca0a93e5d00a9b36e925f4"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxext"
  depends_on "libxmu"

  on_linux do
    depends_on "libxcb"
    depends_on "libxdmcp"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "unable to open display", shell_output("#{bin}/xauth generate :0 2>&1", 1)
  end
end
