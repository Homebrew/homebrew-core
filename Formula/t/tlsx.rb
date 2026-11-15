class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "02e29cb128415e673312b7176e95126891a223d29e54dce898d5a0277a7d35ea"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe05d8f7c08e416172021ecbc31f9f6e25b84be1cac9176506d582f6011aab67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5607a68a665ce0f94159f70a776790748e94b9bb08a6d976e2965716766e4bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26b2365a0b68eff0c409f97d1dbce232215564f5a8a6ce89b3e322348a6b67b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2c52c4dbf8cd10141aa242a4195edbf7b3b411559cbe8418de37a6d684122810"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "457e4404fcc1b6efcb60114f93f024343056cbd0a765c7f07b1705bb2760231e"
    sha256 cellar: :any,                 x86_64_linux:      "3265f1adf28d14fd58878e93b9385ef2bfc3554d81000afe2fdf3cecb81dddf4"
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
