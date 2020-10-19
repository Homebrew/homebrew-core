class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.21c.tar.gz"
  sha256 "3bfe783726f82c1f5a4be630ddc494ebb08dbb69980662cd7ffdeb7bc9e1e706"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "4f2c4bfc6b9252f00f42629992debe0953976633f721e03f585997ad085efb39" => :catalina
    sha256 "4cc621a49194971597f1295b201dcbea188608b646eaa6b3a3cfd3fbfc9f4533" => :mojave
    sha256 "b632286e7df5075fc5b5d19fad5957647ec0c6b5796b972ac62bd6132521f734" => :high_sierra
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
