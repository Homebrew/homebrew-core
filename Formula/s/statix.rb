class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "547ee83df5814c18f8577b5ca25a1f12a416900b6eaa95821386a28090e8a89d"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccd7f535c266592bf940e0e9f53d85730aa2a4723650d4a3e51836cd35f364b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73739173a85eef1d38fed56088cc45c3b806713a5971579ee65ff738de18c16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0f89654f7ce6ed5a63fa94fc69074d948a1319a453e43d7772285c3bced903"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d45ddc687143cf2ed81ca01603697d6f40ce1bee9bf7d215822cdb22b85e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "dc66f2510259058f7ac84859143302d1e68b762963cddc5e8bf29a8ccffbdc5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c878dbb9c817cf27c5cd766bc55f660b0790286e2c3c771971f191377ddeee58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519e16e4209eb0dc05b5bf311dee7d24d7c37a7bc375d60efe4e2ea52ef31fc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
  end

  test do
    (testpath/"test.nix").write <<~EOS
      github:nerdypepper/statix
    EOS
    assert_match "Found unquoted URI expression", shell_output("#{bin}/statix check test.nix", 1)

    system bin/"statix", "fix", "test.nix"
    system bin/"statix", "check", "test.nix"

    assert_match version.to_s, shell_output("#{bin}/statix --version")
  end
end
