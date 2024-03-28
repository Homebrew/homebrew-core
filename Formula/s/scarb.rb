class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "757212eb2f24eb466d94bbbc2ad8459cdfa9401c61d384ff1e75f8cd82641bd7"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "586cca84ababf17162fff5ba22b89f7c9cff125a2d9dfccd162f2dd560d5e226"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cd6059ccc76fd0ac9a2b2ef34ddb95b441798d0e59848f3b5a455707123ff99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66a7f6ec9752f7ce30877cc9ea481fdc829cbc45f0a1d247ebe8257990e01d8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f80574285386d79c5e8085ca1a3a98525caf6744076ad0470c300df126ba515f"
    sha256 cellar: :any_skip_relocation, ventura:        "ca2a64ab4b8162952ba77b05ab6a83d8d784ffe58fcf0248d3f14df3bce845e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ab682729f5206f2200640915dd290e2b5bf6a1c5cf9eb86dad9177e470f79b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec95276ff39446e9e07a4abd9d5e977e4d457c3c2876594046f050ba276ea665"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
  end
end
