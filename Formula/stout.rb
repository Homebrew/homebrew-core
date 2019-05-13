class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "https://github.com/cloudflare/Stout"
  url "https://github.com/cloudflare/Stout/archive/v1.3.2.tar.gz"
  sha256 "33aa533beda7181d5efdcfb9fadcc568f58c1f7e27a4902adf1a6807c4875c99"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b3f55e4d72a4430c9c85a47321057bbdfd112b4b8772417aa8a0a8eee9cf1b8" => :mojave
    sha256 "e2774d1b1ea912934176fe6e68a3b7577239da41bbd15b1a71712a54f315a221" => :high_sierra
    sha256 "144aac3cb78b98bf773b19e63e7eb3598261ab264e30b6d39ee3c8fdb9442cf9" => :sierra
    sha256 "74dac56156c250fef9de8ebae64a1d6ae7b93c068a43f602a4debdc1b23a3945" => :el_capitan
    sha256 "bc065cf4232169432ce91ea22c456c6891f00a386055c795131dc82572f5a3ae" => :yosemite
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
