class Vscli < Formula
  desc "CLI/TUI that launches VSCode projects, with a focus on dev containers"
  homepage "https://github.com/michidk/vscli"
  url "https://github.com/michidk/vscli/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "0e33647b18f805ca2ddf67831df62b03de4cfd96fe1495cc0e2ad9cea3bb06a9"
  license "MIT"
  head "https://github.com/michidk/vscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e8493ee28ab2430c0dabd4d09696370349d6eac2b216228fdaa3bd54c4590fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "953c3b3f8177f6a161f0d9d6f16c6c5d352253224c94435196f68d05b37523d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be4ce227301b92660cd226c09cdc627e7b635098719c6c253d1d6f49fc78cc05"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc116db5023dfb1cdc27cd43fdd9e2f429715a7a34a47dea03830a287659b3e"
    sha256 cellar: :any,                 arm64_linux:   "f42ebac0f93e61285a342047c30d8a9fe98b02dfe882cff0964e0afa27cf9697"
    sha256 cellar: :any,                 x86_64_linux:  "3c137d3053e9ee76a2aad1c6ed44562cb3b9c1dda3427d9fe0766930d71385e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vscli --version")

    output = shell_output("#{bin}/vscli open --dry-run 2>&1", 1)
    assert_match "No dev container found, opening on host system with Visual Studio Code...", output
  end
end
