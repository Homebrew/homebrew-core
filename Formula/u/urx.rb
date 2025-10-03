class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://github.com/hahwul/urx"
  url "https://github.com/hahwul/urx/archive/refs/tags/0.8.0.tar.gz"
  sha256 "616da098ff8f044007b55642f9fbc52c8310f667ebfa64a43bbba9ee64725aa2"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6dd267008bc40803a7a9e2c3f163e2a1cdaa8d513c767eeb009ea8bb0912c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939f467d16a57621fe8f15ac7411e030844ee2bdd128860e2723afa0dacc2826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d26ba3ce1d6a804045d6d39d432d0e89b29a037ee2988583179ed9845ee4b2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2813f0283278d238361b12a6fd4fd77d8b308a67784c5770cccbf9d51ca324c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3c32155a5d8952863cdeacbae2f398c3aadad2a2159d1c42f5a93d7bda92b2d"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2879cd695d6823be6766cd01cfa04649f72ff02b278b2137ad9d82e887b9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d68187c02cd476dc6f538d1f0392f2ef75ed679f92adf647da269f6cc4ececd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c720ff72528d8ca45f5db518f29461c36cbbeee59a1944f3d5f89465080e9150"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end
