class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "d01de7df6b47f56f9c436d20da683d799aa263213ec450c929c520a117cc29ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbad6442326939adff9103b3c4ce7479e3756204bc5f54137dca5950b1af84ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e587b51cf2da699855815cef4f79febeea839d6945dbbbec23bfc0fc571d311e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89af3731ab10ce6bd11f92046c4a8a72b1e59a96fc04026c6cc1d9a880cd9177"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac46ed0f8a91f81fa646a64674678090c50bc9dfd0419bc0c5972a172e20a86"
    sha256 cellar: :any_skip_relocation, ventura:       "e54b805e730323437a03333c86476645f17da0d50624111c1dd4643161a4c08d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ffe698d514ce64600447a454bb00841bf88af07e258548952a6eb1247040aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c4cfc5932212b668eeda4271a6877ca9a88aee35549daa689b36b044cc23939"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
