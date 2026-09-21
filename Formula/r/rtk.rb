class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "74b226ab00b8698d5084402893c76d93189493bd332b99d0b1e681d1ef860eb8"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3c21c970af4d008db0b703c8b50e5201b94fe4a08b61aa57b07cd22aae0c123"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2f3d7a4b24a5c1c4fae1203aff57fb8739354b4a14be8ad4d8ec99d8ae54c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d46fc58ee7ada121604048285b002093d78aeb9067dfea80d302faf8fe44d894"
    sha256 cellar: :any,                 arm64_linux:       "ed2ba35f56632a4a8b18022e77bd3b0e3ca358b36a1c0c26d609e3fc7a0a432a"
    sha256 cellar: :any,                 x86_64_linux:      "fed3cb8536d3017c33e40bd652eadefc77b746b8498d7472a0629910b81ea126"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
