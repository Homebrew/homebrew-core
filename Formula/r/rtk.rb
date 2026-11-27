class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "c5068215a2f3d8df7e1f6c98cac1863b6fa69bd84f282669516fdba383440ed6"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    manifest_sha256 "ac918edd0f69fd597c9b85ba3d3e9648bd70c29546b67702bdc8566b928d9012"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8e2913824b76cf9136fe0a13218ae0cade1d3eea72ef379aa870a5270f37659"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89021f16223ffb64f07a994e3430300202df8182de9e154f9365ab3772ed3b8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c1d275bc857e1cecbcca6dc7be09f10430a860841990c069508d15d441fc165"
    sha256 cellar: :any,                 arm64_linux:       "74d82c2982406085de26470cbe4dbf64e0dd0a11d5c77359d340a5a56c9a4487"
    sha256 cellar: :any,                 x86_64_linux:      "3de17502b704833ef110072892d73b0f5efc90d3e9df01624513e74e27e1a2c9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
