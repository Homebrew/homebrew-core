class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "dd9f519d4fe63e596f49e259aca3016c3da635b671c45e56b18baea0f6e264d4"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02deea8768753b624cce69940fa2b665467c1735b1fb2d18a7a5bd94911a7c3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b524c592d641858c4adeb567e3c4d1678b4e72b7850bfa58b5603b464dc65efa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1d44339042ec17be2c0701f54ebc0dec54d5fd921eebc5da40066f004ad1776"
    sha256 cellar: :any_skip_relocation, ventura:        "71c0ce53636245c0a132fd20b688f4a70517c8e2707dda266531a8b5dd087326"
    sha256 cellar: :any_skip_relocation, monterey:       "5734778b777342207c9b62fe1af1df885b8a77190c7cc0f2ae254a1224dc5b62"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb34e5c4b14fefac21f4a9ed2eea55681738e2cd9612e39f15f6ff9a4e8d9af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b827252128e7f915c2ec5a50c3b457302ce4e5e552f37010e4d613f751540f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
