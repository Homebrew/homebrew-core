class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.1.0.tar.gz"
  sha256 "464d0fbabae27ed45a7cb34f313f716af5f88a96a1b41e094381832c1a72eb5a"
  head "https://github.com/vi/websocat.git"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  # This formula is based on ripgrep.rb
  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "ssl"

    # No man page available as of websocat version 1.1.0
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
