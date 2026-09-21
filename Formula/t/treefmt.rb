class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "90993f858b376c0a0ca49920b9679dc774107a96fad8ffc3808809c6a82f4ece"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f7850bd5c97f6005c57cd5613bc22895b9478beb0315653299bc1b2ebfb5fa8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73ad0724a4f306f79e231bc9d4f1c940309dae789653b97a13da3c03ba0d4331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73ad0724a4f306f79e231bc9d4f1c940309dae789653b97a13da3c03ba0d4331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "73ad0724a4f306f79e231bc9d4f1c940309dae789653b97a13da3c03ba0d4331"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06d0f3608c7c737f4c3d3676c605a75ae9f1cc9e9e39fda4d05f5bf5e7bc9f36"
    sha256 cellar: :any,                 x86_64_linux:      "3adddd155cdefb0b06a8ed90d69173996bbb5e96577cb75bfeecd23afdb57af2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/numtide/treefmt/v2/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find " \
                 "[treefmt.toml .treefmt.toml .config/treefmt.toml]",
                 output
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end
