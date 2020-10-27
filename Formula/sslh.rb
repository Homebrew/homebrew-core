class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.21c.tar.gz"
  sha256 "3bfe783726f82c1f5a4be630ddc494ebb08dbb69980662cd7ffdeb7bc9e1e706"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "27e1dfac1019af43e51729fa85884753ab1b14aa53c4f969d4bc8acdda514ed4" => :catalina
    sha256 "06bf2bc9eb2c4cf200c3c05d22db1b3e30177418993d3ed02f068c9f4c12ce5f" => :mojave
    sha256 "1b53222f84e259a92b6eab2cd172b4b860e7400bc73b76db141e79a5ed2b7693" => :high_sierra
  end

  depends_on "libconfig"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port

    fork do
      exec sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"
    end

    sleep 1
    system "nc", "-z", "localhost", listen_port
  end
end
