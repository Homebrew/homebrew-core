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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f6aa50ee21327847f916a61422569ae7fff43c92024e3413fafbf28248c02f4e"
    sha256 cellar: :any,                 arm64_monterey: "4e96a37131487c816cde4020cc70a7a595c7b9cdb45ea7451484bb6d89f7ffcd"
    sha256 cellar: :any,                 arm64_big_sur:  "580ce7d208ec94379e1080ce76095b292535d6109b5e7bb6d133711e5e9e0151"
    sha256 cellar: :any,                 ventura:        "75fad6c257fd4845d78eb46c1586de8aa3ba450a9d317ff87b327ece2222b9b2"
    sha256 cellar: :any,                 monterey:       "4b77fd5affd99347d487a9da3fdac453e03eb1d9f114e10a1a7dbfe6e771e3ec"
    sha256 cellar: :any,                 big_sur:        "72ed3ae16d6f7cc35e184eea5ccf5a88bbdb9a0aa7506d3acd960c8348bebb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9cd03f1295c55fc5dc62d20d77a75412a113b69e2506aed038d3a7389768369"
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
