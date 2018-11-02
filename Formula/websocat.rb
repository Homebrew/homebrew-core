class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.2.0.tar.gz"
  sha256 "e1a6021770c9ae5b364eaa74b7435f259c5d84bf5c7210cab7f0c775fa2158a5"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  # This formula is based on ripgrep.rb
  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--root", prefix,
                               "--path", ".",
                               "--features", "ssl"

    # No man page available as of websocat version 1.2.0
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
