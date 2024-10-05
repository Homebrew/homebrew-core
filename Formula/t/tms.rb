class Tms < Formula
  desc "Tool for managing tmux sessions with git projects"
  homepage "https://github.com/grvcoelho/tms"
  url "https://github.com/grvcoelho/tms/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d4b32533bda5ce02e8e21a74e7d1d49987964147b327dc28669f10c8d398537e"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test do
      assert_match "tms #{version}", shell_output("#{bin}/tms --version")
    end
  end
end
