class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "https://github.com/cloudflare/Stout"
  url "https://github.com/cloudflare/Stout/archive/v1.3.2.tar.gz"
  sha256 "33aa533beda7181d5efdcfb9fadcc568f58c1f7e27a4902adf1a6807c4875c99"

  bottle do
    cellar :any_skip_relocation
    sha256 "95406589caa2074808e99e54b755c2ea7b73fdd3ac8528c1a7f124895f3c1be5" => :catalina
    sha256 "7d90dec0fbc23cfc58b56261957818a0fb1af5c77086b1979b77ea1196484a25" => :mojave
    sha256 "cfff658fcb5319cd6a5053c645a9679d3db94e9dff4fbe91ae488ca31658a1fc" => :high_sierra
    sha256 "26554af96b6044316abecb1a2142e81b1aab8315bff941cbdad9b39fe143b74e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    mkdir_p buildpath/"src/github.com/cloudflare"
    ln_s buildpath, buildpath/"src/github.com/cloudflare/stout"

    system "go", "build", "-o", bin/"stout", "-v", "github.com/cloudflare/stout/src"
  end

  test do
    system "#{bin}/stout"
  end
end
