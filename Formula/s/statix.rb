class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/oppiliappan/statix"
  url "https://github.com/oppiliappan/statix/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "547ee83df5814c18f8577b5ca25a1f12a416900b6eaa95821386a28090e8a89d"
  license "MIT"
  head "https://github.com/oppiliappan/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8fa52bb92332387d05946edc0f239ee829806fb2df9db218b9a1fdc93fb71f3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b21020e92407c357003a7aa16dffc9449c53323f717ef2696ca9d07ad3535aa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "967a8079ab2a27a7896ef2ecfa52f12025dda7ffb533df5948382b5f1136c68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccd7f535c266592bf940e0e9f53d85730aa2a4723650d4a3e51836cd35f364b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73739173a85eef1d38fed56088cc45c3b806713a5971579ee65ff738de18c16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0f89654f7ce6ed5a63fa94fc69074d948a1319a453e43d7772285c3bced903"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cf629faab1aad35a3ebff2293ea09ed19a2a3e2fd661f339a37f8f8c936cf80"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d45ddc687143cf2ed81ca01603697d6f40ce1bee9bf7d215822cdb22b85e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "dc66f2510259058f7ac84859143302d1e68b762963cddc5e8bf29a8ccffbdc5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c878dbb9c817cf27c5cd766bc55f660b0790286e2c3c771971f191377ddeee58"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9d738f4455a81197f21c8fe2b73d4b35948e7d98ee89e66b0d8c5ee87abfce7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519e16e4209eb0dc05b5bf311dee7d24d7c37a7bc375d60efe4e2ea52ef31fc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
  end

  test do
    (testpath/"test.nix").write <<~NIX
      github:oppiliappan/statix
    NIX
    assert_match "Found unquoted URI expression", shell_output("#{bin}/statix check test.nix", 1)

    system bin/"statix", "fix", "test.nix"
    system bin/"statix", "check", "test.nix"

    assert_match version.to_s, shell_output("#{bin}/statix --version")
  end
end
