class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.8.1.tar.gz"
  sha256 "ed4ac1aa2605c5985482002d201114f30b4998b8ba247aee86103f59386a4aed"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a20941e2f36c8ee448c90728ae412a593ebc75a56dba6cc4cf6d581e580197cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "d451b36b4d3f0aa3b620503526355d3e8caafb61ce2b47a2254ce20946d4927b"
    sha256 cellar: :any_skip_relocation, catalina:      "3c36b35f1c940eec56fcc8b8dd5bd702ffb1d06d803ddbc1f9f1cae4777ad119"
    sha256 cellar: :any_skip_relocation, mojave:        "c0d4a665923aeedf7b754935295e4bdf64c44d2e8d08386459148cd061533c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb98539452107609b0e0cd90654ef13b3fc0d4274d74733f3b2208ccdfa93749"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
