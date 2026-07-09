class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.8.tar.gz"
  sha256 "c1d238b8620ce8e9e48a2b7e4b824b2ed71c2fe89e9e3fa3e53c88462a91777f"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ad66d07af6db692ae23fe69d869bd184ca5b520b55bbe7eb10da5c36bd7e9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd79c07c96b5052e8b891e6ff5f620500b326f151824971d305b1391d01928d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a711ef4e2d4ef83a7b2f661f0a3af2eba819889b4c39722e5692abc76845b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "35642154ebc05ac0d6a464175086eee1b6cf492b40d4ef4443638498fefc341c"
    sha256 cellar: :any,                 arm64_linux:   "feb9fc48a52efe184beff0f16c382c425a3a67b9b0ec0a9660a1c8aad33b1bc1"
    sha256 cellar: :any,                 x86_64_linux:  "0dcf1d06297a971d4df4cb0458ec24a53f0b93b859659858ba1accd1a2c85404"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
