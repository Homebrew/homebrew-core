class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "61f654815cef79303e872aa6fed2ee4f9c3533239048455564a6033ea4e294b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ce556859118304f18778767d6a8c5fe025c11af588cadb8a25f4b0721536af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e7fecd371c2e3003b82ef379cd5e152263ed9c4d5d60dc2528c0b351f3e9bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82bd480a4ae44c99f165da7761fe9192de23f546bada1d28f9d44b5fa3d80f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b41e665925d349ede9df47277ce398a7763be2ef7186a74089f8a77ab8ec193"
    sha256 cellar: :any_skip_relocation, ventura:       "4b292232f70f754159b9a65bf8d94783e42abe5576bbb00078cef00c0d4b6b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32f0997f781bd40d5921b0eb46c34b37e8a6af0faf63f5e9d31bd607e03987d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
