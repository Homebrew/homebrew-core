class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7fa22515bab031b157d774bf6aa1966b57ea735734c8d75c67a886e2c086c2f5"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "310f465b5b8ceab9ec074ee7aebb89efb8f18ceb6ee1dae9d9f1c089fddc92ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f268c8228dd222d78c7b285ea6c6ee2b42b1e4ae7d3f352e8a1a1c6e9c7664e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203feab7511c58fd41aa15f9f5d61485dfb81f41cf47b3f8f9248ee33f2d3d57"
    sha256 cellar: :any_skip_relocation, sonoma:        "8396c5a59aa390f0550544cb5764df69751712ad65be8c9dc110f097145514ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e4547f2ebb9f325e2d85794423255185f1d6a3de19344c4a81378be49d97788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb5c108af1c3edeedadf89aabf08dc4e476cfe404a41ff5ab793b7d03600266"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
