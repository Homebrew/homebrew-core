class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://urx.hahwul.com"
  url "https://github.com/hahwul/urx/archive/refs/tags/0.10.0.tar.gz"
  sha256 "d05f11d2cb2994c3d79b15a563685cc2b8ca5d9acf4af8ab659ae1d280d58931"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "381d0abcb1b8f6d1718bed9ea9c0409d97813a9d09a2091265a861ca66135c37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1bb9fb1a4c943460e7f28fa7529f9fb721640efa5199966ca67414eff543cf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93cf8a5730338673c973957ca9a0d5d6a12dc66a580f0f1aa4a579b96fbcdf0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a9307d46328586c75ce2ffcdc947762f4645cbe0df984fa4be6a68ad5dcf4f"
    sha256 cellar: :any,                 arm64_linux:   "cc40c7fec7e4c8042ebc15d34538e6b05c632c0a9ea2da20b81dd90b5734e9bf"
    sha256 cellar: :any,                 x86_64_linux:  "281af0c4dec67b1320d7e509fdf1b93cf00f95e062223eff6f73616a13cd1af3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end
