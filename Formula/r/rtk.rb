class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a0959b8749c9b7872b56c63515736ae0b9e460de06f502ac12ae2052f8f59a01"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "671d7d4c002897127eccd3319eede4770c4e4a08412e51427dea4d8ae0ac72fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3fe888fa8d785db74c53441a893f57c13f364bebd08244979a73994866aef430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19252fc1505a354c075586d064f016f85b20f865588dc3d09aef0f87c9884963"
    sha256 cellar: :any,                 arm64_linux:       "ef6d10062877e8ccbfaca731553e7f371a2366a7687b1a3ee99ff22c294b133e"
    sha256 cellar: :any,                 x86_64_linux:      "a984bbad45d05b22647969258ac212f81fba9ef02f9622c0d466efbb42c92353"
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
