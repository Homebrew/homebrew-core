class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.1.0.tar.gz"
  sha256 "910f13bb46347bac373c4fd38e2b13a47d396782d48d7f631fc5444beacbc3a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b6d84965b7650c09b02c1b4db556942c6c7715944f567a23c02fef49e52fb0c" => :mojave
    sha256 "eaf801b9852947b8648a64877a2649d4a1fc2a375092dafc4e6defcbb7d48d6b" => :high_sierra
    sha256 "ffdabf749e26b8b68be70d9269d0fa0c9a1d145fbfd915d32861446028cb1c8b" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
