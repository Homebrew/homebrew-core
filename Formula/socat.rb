class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.4.4.tar.gz"
  sha256 "0f8f4b9d5c60b8c53d17b60d79ababc4a0f51b3bb6d2bd3ae8a6a4b9d68f195e"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "623b6a8ffbf52e2f49bd91d7f67ab4831656969f8915a855ac9141ada45950a1"
    sha256 cellar: :any,                 arm64_monterey: "9869f1abbc5e6f06eb88b9d105b8cd7a51104c3fc61445a137c7df696ff5bbda"
    sha256 cellar: :any,                 arm64_big_sur:  "6fbd66e30a037ad2894cf36efbe54246ea4b121d83c1c58ec46f0db8ea949be4"
    sha256 cellar: :any,                 ventura:        "582473222d1b540d10b7526d51b8521cfd709bc5e7ac73d6a08a2b0c7530fd7f"
    sha256 cellar: :any,                 monterey:       "53f46b767cb68336f0b8df622eb3ba6f05d83c1918566c6394336ed36c1abd15"
    sha256 cellar: :any,                 big_sur:        "16de00d162871d7911ac6c31ceec915041f84252dbafa5629a1d9c659cd549cb"
    sha256 cellar: :any,                 catalina:       "9a047ed686313839bfb8ed662d4e9ed7d3d682631b36317ce2b4bba37fdb2ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2658491f6539bd6f99a06ab1f7c9ae2c8b59313ccd5adb53dc64973cdb0f2f4"
  end

  depends_on "openssl@1.1"
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
