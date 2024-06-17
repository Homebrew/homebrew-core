class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v14.0.1.tar.gz"
  sha256 "e4262fae2c89efe889b5a3533dc25d35dd3fbaf373091170f20bcc852017e8be"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d693db20df557cf47859b48086cca890367bb11d561fd1d7560af82848ecb2b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4f647aa7ea5585e9f56f85c30865d36b7f175eb178f6c32b552475b041820ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c4bf6236c4818587e71ec9444ad7a5535adb80bfe32e6af99614225958faf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "daefb7ddde3929d87e0e1f4dfccc670dbb889bd7b1c5227634f66508102de2d0"
    sha256 cellar: :any_skip_relocation, ventura:        "1a200942d918ef3ce0f977d6e5c9d7b0b4481be871d68e3858838b2e881f9f96"
    sha256 cellar: :any_skip_relocation, monterey:       "330d758b5747aed37f03b40335a5722e0852f769d17033785eb7be8f761c2180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab782c5b706304dd871ea68c8dac3924be709cbbcaa79fa3260c70a01be87758"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
