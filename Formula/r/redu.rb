class Redu < Formula
  desc "Ncdu for your restic repository"
  homepage "https://github.com/drdo/redu"
  url "https://github.com/drdo/redu/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "106a0e93d2e3964f042afe46c7ec19286f40f27268b242c168811699d3d97475"
  license "MIT"
  head "https://github.com/drdo/redu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dbd847b6a545d1f3fc22902736c5faeba1e4d4860952404322ae658eae169e51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ff3aac2d53f1d7d0ba43bd743ec74904483ff2823891b496ac95f3a9c835bef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d99540a84c307f690dcf75e61932da4d82bcae6972074a6c11201e91d67fe0cb"
    sha256 cellar: :any,                 arm64_linux:       "08d3d908de883a6ef221e59971319a96bed36d39ef20ebb0a572511666f4eef5"
    sha256 cellar: :any,                 x86_64_linux:      "c5179a1b73e0447a1a30f48a98283b2e085da06bd7023fa72060edadac707a2f"
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
    assert_match version.to_s, shell_output("#{bin}/redu --version")
    assert_match "Error: restic error", shell_output("#{bin}/redu --repo mock_repo mock_pw 2>&1", 1)
  end
end
