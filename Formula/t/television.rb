class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.11.3.tar.gz"
  sha256 "3b589b6552fc741d8527d3b1a6a4b57ce08b50b2203e4baf4ab151f5dbf57cc4"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f798747725aa45e7fa20e98b0b4ef3e8a73c5a5c9257dfbbf32709854f82c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6beeb676f6722c8a60692223821ced998d047df559cba7339065f499d621fea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88149a0f445fc1ce1769534c852a15aead12ddef2e625107b44dd13a4e53e909"
    sha256 cellar: :any_skip_relocation, sonoma:        "6deedbff3c5aaf987df415798664f0759194dacae3d16312a17672788c233551"
    sha256 cellar: :any_skip_relocation, ventura:       "4460e096811735683734313de9dde428caa1d32009ae5acd28892ac7df56a846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832e63242bba4022934f2f9cf02fdaea6e1207f6ac30c52cd1ecd0d1f944341e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63382498fb27fe2f6c1cb9b73e4363d40fe201cf66e13a2bafb216a70215f38"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
