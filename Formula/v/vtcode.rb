class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.46.0.crate"
  sha256 "65fd34234822ceaf2a789e9f04bca8da5c7fbfb2d8e31757d101165341417aef"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca52a6a6a7825adf71aa15e1e0c0051645c86c174b43cc6954352531a08d4e72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72565e5ebe8d87070bf30df9eea50558cd3c41d94ffbe9903e8a33c2cc90b748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8253771ec5aba12d1bdf54f65a37e36ce88773c90a93b410ff02c5d1ee03425"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc5601efad199fc0b9bb330e188dec9c1f20d99839980821ad33c457ea891741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "397b1f697437982f93fa7ea3a32efb6a792fe82d93555202f173a2fdfbdf797a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71708a7889a50a231c8b16b599d4f56bb25f8385b3c6d328d96c3e5bb2a97cd8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
