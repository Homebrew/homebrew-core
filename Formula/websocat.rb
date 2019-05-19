class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.4.0.tar.gz"
  sha256 "bf4efd28da077856ddb6ad8d05a4c9419c505825512cc9e47a06a63793694eb8"

  bottle do
    sha256 "e828460237de4ad4607fec9e703037f349e9e70b5437fb0bd7744aa779a971b4" => :mojave
    sha256 "b8ba671d1582b57bdc9b4f691e68221179ebf6d50b1c3b3c259a6451c185ad47" => :high_sierra
    sha256 "2561c8003b59997794008f409290fc719906437baf001494d48b31967ef4184c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "ssl"
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
