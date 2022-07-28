class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.5.tar.gz"
  sha256 "f505d6154a204a834c1ff54065aa43fb64a8f127db433a30eead16c74483ebb7"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
