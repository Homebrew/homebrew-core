class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "620455231b34b4e2c51dc636d2a2c34d7c17edca87e38b6c268b3cb11dc59bc7"
    sha256 cellar: :any,                 arm64_monterey: "545f8479e92a7c8dcf0d9a42a5c0027e34e8760596ca53e308aedebe65b80477"
    sha256 cellar: :any,                 arm64_big_sur:  "2f66cb207fe048720b4497e774752de500d005b4bcc7bd45ccb164ecd11fafc8"
    sha256 cellar: :any,                 ventura:        "915c2a3c455ca7e656336d77d193ce96af60d46cf2e90836c55b96c9c57f251d"
    sha256 cellar: :any,                 monterey:       "c2f16c9907f9d412da320f03902cc1ff86af807acdf9b7581316337e561a711f"
    sha256 cellar: :any,                 big_sur:        "701102c6cb8138920a8ccf7aae6d89ea247d259d17f7f4ce3e4af46cad516802"
    sha256 cellar: :any,                 catalina:       "423dbce4e76710fe932fc4d86fa25b39ced8f138d781fcccbc3982ce83136216"
    sha256 cellar: :any,                 mojave:         "59ee230b63a707bf9c1fd966ec003c14ca16c7e61a331b765e31a1ba4b7db867"
    sha256 cellar: :any,                 high_sierra:    "6c6b704e5f9830e0192383c53717f64b0af48119d6f0d96d78de521820a6c84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76dc36073ec825c62714e281e7e02cf6a159a5f43a27c2011440cc683cebb3ed"
  end

  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "libxml2"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
