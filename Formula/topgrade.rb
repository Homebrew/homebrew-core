class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.2.0.tar.gz"
  sha256 "181ac08ce4d9754aa4ec56d5bc7399b4cfb8561c44c7ff5dd55401bf9826eeb4"

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
