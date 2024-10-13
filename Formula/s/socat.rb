class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.8.0.1.tar.gz"
  sha256 "dc350411e03da657269e529c4d49fe23ba7b4610b0b225c020df4cf9b46e6982"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5678f2ea824311cb154d6ef61e14e7d9b796f38bc917ff06d5e6c9bc581ffd6e"
    sha256 cellar: :any,                 arm64_sonoma:   "ce9eb0d339e56ebf7313806da1cc1db76ebbb7d64370e41a274d441a0e7d13d7"
    sha256 cellar: :any,                 arm64_ventura:  "c632110822aad77036aaa2f5b8c56825f129509b8e19ce377ee13eb2b063137f"
    sha256 cellar: :any,                 arm64_monterey: "a254848672b79748f4866f9df24914aec385874ea067fa5cfdd605e0f2f1786e"
    sha256 cellar: :any,                 sonoma:         "869b218cfd0cb87da822ad6f9a6931a1befc641c13f5ba467d3653bf5be8b090"
    sha256 cellar: :any,                 ventura:        "9f4c542d4ecb5d9edf1d6edec2908ba79f72742e024ef6ded35efd802d5a6f6d"
    sha256 cellar: :any,                 monterey:       "d42be275b97694e192a9dcfb75571857f8af2cd6107dba65fdae7ad4807417f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d14266504dc4a222d8ffd69e39372ea8abb5fcd8a04a04456473a1ba5c393a"
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
