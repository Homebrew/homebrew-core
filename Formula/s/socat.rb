class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.8.0.3.tar.gz"
  sha256 "a9f9eb6cfb9aa6b1b4b8fe260edbac3f2c743f294db1e362b932eb3feca37ba4"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2aaa10446c3d48a4abae274444c3ab9de518616dec42dde68146220d1cc58cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "137815efa3654ce88233eadb28d740d3fee351d89f2d65a31ae30d1fa32e77ed"
    sha256 cellar: :any,                 arm64_ventura: "ed40e4fd40e2cf47cc732fbe1b188922e7b41d13df5917509fab2335f24f7398"
    sha256 cellar: :any,                 sonoma:        "c418f4b948cc59f250fa1467eed47b1cf088d6a17ea8c94f6525348693af2339"
    sha256 cellar: :any,                 ventura:       "5986bf1538a59cb4ee5d285f54d17f3ee893d993d174ee9ce2cedb2a2c567779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e85c0167c53a685bb332c47a18e40fa0f6133783c70acc3db6a43189c8f98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90337fcfe325651b99280dcb87e3e9bdfc4ad25dfaf7a9fbb7227fac4ff68cad"
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
