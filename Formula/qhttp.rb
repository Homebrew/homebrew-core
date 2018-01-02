class Qhttp < Formula
  desc "Very simple http server"
  homepage "https://github.com/skyflyer/qhttp"
  url "https://github.com/skyflyer/qhttp/archive/v0.1.1.tar.gz"
  sha256 "9f62598e621da2faf40fe3dc9d1266dd5dfc21bcc054c5e45edd6b2ba3effb9d"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "qhttp"
    bin.install "qhttp"
    ohai "Run 'qhttp' in a directory you wish to serve"
  end

  test do
    system "#{bin}/qhttp", "-test"
  end
end
