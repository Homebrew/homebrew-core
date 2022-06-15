class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212a.tar.gz"
  sha256 "d986b429655dce36629d1821ea6f32d65cc418f7d22b1ea4330621bffb35c18c"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea08ddc851dd29feedbaa0a8f20bb178c268df5c9497e2043b2c916b7434eaa5"
    sha256 cellar: :any,                 arm64_big_sur:  "1066b95b6fe4fe29362028df661fea8f790465da53f22ac00329be16d3d25e0f"
    sha256 cellar: :any,                 monterey:       "bb3acac54b6c08565922731332b37642b0c22d9d155e91f788261dc4f4917a92"
    sha256 cellar: :any,                 big_sur:        "25313db0f5be0e859b56a52fb05ee1ec648ccbc46f15bc17c5bd298a1ba5362d"
    sha256 cellar: :any,                 catalina:       "581e363f70aa19e814f94e2df445785801be56b30141574bc4a1f625c0cc8cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "474e6d68861e2b138f51b8db49ab28c12cfb7e16ec9612e88074e3fcd6ad550b"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
