class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230323.tar.gz"
  sha256 "ec78bde05d08087a3024e40e7325888229ba6c80b15f313b2203936472838f1b"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "05ee7b82ec51045f9c22104723c798938f37bda2b0b8d3a06d481b8a5312b71d"
    sha256 cellar: :any,                 arm64_monterey: "2b8b1e7d3bbf961902cf963d76064da38d15678ca2c7f170e8b246937c9360fc"
    sha256 cellar: :any,                 arm64_big_sur:  "597ad046280e2274f873760ae1ba288c61d1f4a39a92d500050286ce8a788f8c"
    sha256 cellar: :any,                 ventura:        "33a4105dc284b926c6faacb60e4c1033b32366b66f7051dd4171ca237654c277"
    sha256 cellar: :any,                 monterey:       "a0a4c1c3aa0220eed8ae16617149453c5c95940564c1a7a45419321900980ffc"
    sha256 cellar: :any,                 big_sur:        "5a445603d9f30c4d8366f97adecca5a78326ba9065ee4af27ffe433d61bf15a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e17c405673f5d03a9ab127a1c2497e890e163875c53061e30599569f3e6b5a70"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
