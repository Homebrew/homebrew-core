class Sigi < Formula
  desc "Organizing tool for terminal lovers that hate organizing"
  homepage "https://sigi-cli.org"
  url "https://github.com/sigi-cli/sigi/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "fff199ed3b717377af733324fd77568c5e3df8320c53bd26e8bf495d60818e38"
  license "GPL-2.0-only"
  head "https://github.com/sigi-cli/sigi.git", branch: "core"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6919573610314e15c997ee39d2bad28f9af840473162d61c58efd5839f7c297d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "86da61c2b5d794b74bff13924cecb7f610034d1f4f9a25e7eace70b90cc57539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e26706b19c0c5233a103c692b66c1b45dac5ebd6a735ed4e6d852861e4c3609a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e15523164561b9823dae8d7581719b486833df10ad957deea4b90420ae3baac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74e53c2d8ebc12f0e907082ebf6de4fabd1621f73ab8a4d47b7f7b2d4ed7155b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2d5f45cc3906d4191ce72b5e374846e0c5c57da3b8b61388d1b2b161691d7eb"
    sha256 cellar: :any_skip_relocation, ventura:        "3e61dd1fae21e604c077e1d83b6dab9add32ab5b77929bd80f7b10ba47232ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "3473b320d33aea1cade3ba6927d4cf8cfe835a9086caba42898ff34177305397"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "72e91818ac3c30e6f28617217c3b5eb3752fc013a7c94d42fa36686d07366846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9956ee5542d2289d376febb6d44e752e588ddcae44a71d4d89cd2da14983f259"
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
