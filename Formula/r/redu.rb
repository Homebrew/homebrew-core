class Redu < Formula
  desc "Ncdu for your restic repository"
  homepage "https://github.com/drdo/redu"
  url "https://github.com/drdo/redu/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "e7459b4dd3e6d3627c6902aa1024e3d33c4bd3474c9d55c3fed917fa28c64526"
  license "MIT"
  head "https://github.com/drdo/redu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ab87218064df0d994b2bdd1c95004ff0f9332b12387320b5376d58c3d55ceb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158b7091134e0e26454553a74f9d09da312280635e17a0269879f0efa4cb757a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e35f33a54ee2f8b77879f0df0dc6d52e4569418e8d1012dedb82f48439bc8dbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2ff2f7475f615f8d3b948395e267f759e52497549ff0e13678012d8e374cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e54207d47b900777fdd9ea74fd13a3245af0a16409db0d4e1b96a631684491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2605c8a58b070ff549446acbb804998d9e2dc2a56ca3b56178e8dfe66d0502b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redu --version")
    assert_match "Error: restic error", shell_output("#{bin}/redu --repo mock_repo mock_pw 2>&1", 1)
  end
end
