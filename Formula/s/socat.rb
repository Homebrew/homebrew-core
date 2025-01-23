class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.8.0.2.tar.gz"
  sha256 "e9498367cb765d44bb06be9709c950f436b30bf7071a224a0fee2522f9cbb417"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9aa036ab160f852e00acf8ca18f254621db08faa077acf7cb3cb2a789d4f6d0e"
    sha256 cellar: :any,                 arm64_sonoma:  "7603611810edc52d879190e0ff205174490aaca4516a4f27227d783f230f7989"
    sha256 cellar: :any,                 arm64_ventura: "b307f8e247019d7c84341ab3f9fbb814caaf8c3191875c206004580aab5e03b4"
    sha256 cellar: :any,                 sonoma:        "321911c967a6a040aafc91f2a5a78677598002cabd8b4ed58bacbc076b4c6091"
    sha256 cellar: :any,                 ventura:       "411df96a083340a5a553b90a899e383ba7d551ed3626d3a518e9d5e0e2ed1ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a688fbf499b32938427d608ed08462ad31ec82074a4628bee59579eb74583efd"
  end

  depends_on "openssl@3"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
