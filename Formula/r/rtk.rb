class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a0959b8749c9b7872b56c63515736ae0b9e460de06f502ac12ae2052f8f59a01"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c44361f68f060db8f57d52d7dfebcdff2192a184b6833dfc1f8fdbf01b1145d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7414a510ddff3c23b3099720ecb4c6c8a0e97b7ab99d7ea74520d0e41924e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a8f3d86e9aa19ddb1c89554db7cafbe7eebb955b28beed310d8c63870807e62"
    sha256 cellar: :any,                 arm64_linux:       "538a67c7f239a422de6db634eef2ca1f0d78066df779f99218aa52f230061661"
    sha256 cellar: :any,                 x86_64_linux:      "d467386d14bd3c3b7ce85fa80f9014022d975bdeac3b8cddc49fabf5d20411bd"
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
