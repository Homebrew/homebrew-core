class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.4.tar.gz"
  sha256 "d9ed2075abed7b3ec9730ed729b4c8e287c502181c806d4487020418a6e2fc36"

  bottle do
    cellar :any
    sha256 "78e28a89b73b096849654b737ea66b730738cb24f8217c25acd71ba3cb75a70c" => :catalina
    sha256 "5f057eb82e1700ae32da92d5c114fabd6238cba21503f5eaf7190b56aaa35ded" => :mojave
    sha256 "90ee610e6e72158e5e2322ae198f48025f80b351b89029621fdf4b9861391ddb" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
