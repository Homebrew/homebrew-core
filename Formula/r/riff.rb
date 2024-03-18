class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.1.0.tar.gz"
  sha256 "71814d6f5bbe1e039c89333bec2131c1b56f4000796fcdab3026ff6820ce59a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74d999280bbfdcdd7f1a6915dbe9725b4055795af07cf103e581866a2d632ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bf7bbb4c4fadac5d7b0de5e05ad2e60e81fab7397ffa06fd90bdab5f2f20816"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d632a1afc6347319301dc559e9a92d4cd5da94c118591bd8f89317264542236"
    sha256 cellar: :any_skip_relocation, sonoma:         "507350fdc66767f6b4c4e878232e04ee29c57262b7b47aa2238291980bd10fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "af6ec28b7856bbda2b221f59f7248026892a4168ea0c4313efae93e2bbaa4a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "64c8c50c0e1d458a68008f8d9c58ca7be4306c2fccd609feb22826dd128b4253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeab6a9c385d23ceec30ff589bafab926885c2dc82b3469c668e304b9aa5bf0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
