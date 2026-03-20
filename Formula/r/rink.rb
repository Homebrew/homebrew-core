class Rink < Formula
  desc "Unit conversion tool and library written in rust"
  homepage "https://rinkcalc.app/about"
  url "https://github.com/tiffany352/rink-rs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "40048e84c2b606e50bf05dec2813acedeb48066cd48537d0dea453a72d000d60"
  license all_of: ["MPL-2.0", "GPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df19bb6db1b7a86bb97c95d46bde65c6fa3b5087113dad4998fe445bcee51f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73b42e1a62e5bb245650df4a4e786eb42e1da18ec24e86fed7846c597b26989a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6a115a75d540395c9fc6a685efd1563707d6b180836b23085a44a2b5805495c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9234380040a1d54dc20603d586e77fd048230161aa5e01277b1df37d4bf8dbc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15bd40dc2af1906f79d681d5d5ff2088f415e818d219dd2c1afc4156fb931ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e35ad2886b530ae14cf1e7f1189783a19dde7fe5c67b252265c3ab6afbc6791"
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
