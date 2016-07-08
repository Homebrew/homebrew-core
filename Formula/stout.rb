class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "http://stout.is"
  url "https://github.com/EagerIO/Stout/archive/v1.2.2.tar.gz"
  sha256 "e04a44735c4c04ccce63e73d211d2a8c0232594b23c8dfc5c971c10d1aa72aaa"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/eagerio"
    ln_s buildpath, buildpath/"src/github.com/eagerio/stout"
    system "go", "build", "-o", "stout", "github.com/eagerio/stout/src"
    bin.install "stout"
  end

  test do
    system "#{bin}/stout"
  end
end
