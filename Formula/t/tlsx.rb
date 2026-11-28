class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "09d4a82829fe4de008d7fe66fdc48ec9a1e1f9650e360c51c0579198e091c252"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e67dc6b5a5cbe3819268904daafc379368216f267a07a0c37622cb621f82f730"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8078aded2246d2052853710297fd599595f0685c19d96b31a5e2ab4ac680d96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9a1205e20b4d070752ba14cc6f1fa1a557b545de61eb7ab94c7477a4913709f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd20c6d8ea43c53363e1e8a8463c9962d9cf3fca3399f68964fae7e154b54b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c5bf4cffaf6875b895cc9629a51f3e482c6f7db3a20a046b82b9ce00ed519b9"
    sha256 cellar: :any,                 x86_64_linux:      "af813a1dd149745aeebaf4dd113db073fcb84570ebbdcab815fd571d31ce2100"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
