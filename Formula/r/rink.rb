class Rink < Formula
  desc "Unit conversion tool and library written in rust"
  homepage "https://rinkcalc.app/about"
  url "https://github.com/tiffany352/rink-rs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "53f466f4043e0396bedbfdc916aac25cb23c3021137c846d57249678f42fb745"
  license all_of: ["MPL-2.0", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b91b3bf390647ac22c5abdde4304da2179b168bf25d23e9e0da05e3bc4a0f223"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84272cb620b4a7740a36f40ec44b96630c6cd2fffd50f65dd919b771445c1539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b42420d5cb825c64e63f5e9ba12e40fab6fe1e830d977d81949f3ee9c8277fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab0308f1a2c8b32c7188137998be5be574cd6e12c1de7720d6f6cb5f5d9f9d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc24f314147b46f0cfb9f4ef84fc7d6aa1fee05683090a15b5501c26b548f80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269131507cf83ae7586c9b60813f9555e0aec730178ce73fa789097a2b75ccc1"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    system "make", "man"
    man1.install "build/rink.1"
    man5.install "build/rink-dates.5"
    man5.install "build/rink-defs.5"
    man5.install "build/rink.5"
    man7.install "build/rink.7"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rink --version")

    output = shell_output("#{bin}/rink '1 inch to centi meter'")
    assert_match "> 1 inch to centi meter", output
    assert_match "2.54 centi meter (length)", output
  end
end
