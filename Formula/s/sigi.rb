class Sigi < Formula
  desc "Organizing tool for terminal lovers that hate organizing"
  homepage "https://sigi-cli.org"
  url "https://github.com/sigi-cli/sigi/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "a40abce8da7fadd4ce4b51f9124210cc9337c474b40046e4eb6301c42da9af22"
  license "GPL-2.0-only"
  head "https://github.com/sigi-cli/sigi.git", branch: "core"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "757ca1039232442b3540534d73ce4b5d9d94b8763761186535e7f193009a1d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028bd7ae19a22f744a0b7b48e9865e85f207dbcac03facf8c3bb68f8a032caf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50658caf088b4d06f79520e6d06cb4832a0383ffcf6fc1301c0b208007422f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "67161508b2b6547cc0c0554ce385ce6fe36098b25d64b02e4cb092c09660eea8"
    sha256 cellar: :any,                 arm64_linux:   "7aa08f41a9610d2d49585f7b6b09343a89af37f1dcda69fa7fc7e43f9b0d7f8b"
    sha256 cellar: :any,                 x86_64_linux:  "7f33abcfa44f8164cc54e0a4c222e2019ea573a644469daffc20e40b4f1d6967"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "sigi.1"
  end

  test do
    system bin/"sigi", "-st", "_brew_test", "push", "Hello World"
    assert_equal "Hello World", shell_output("#{bin}/sigi -qt _brew_test pop").strip
  end
end
