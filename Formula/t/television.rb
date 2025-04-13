class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.11.7.tar.gz"
  sha256 "d3687a286b4813ab8534d7ce8653908dcf17ad291bc865f3f64c183163f0b650"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33bb3ddda2d61bdb2067e556953ef3aa1485ec21fec2ee8093a86824e169766e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05932d7ed3fd47f0f6938d2aef18d0d8e86429f96ded757a14597cd8db528508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59275668e7bc72c79a652ff4c3aae23844c34734e56bb67a87ee9d38cd8851e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc2040f6bbece92b7c5fbba103f9d5474f562038b81921b460c1774e28f60f8a"
    sha256 cellar: :any_skip_relocation, ventura:       "987361c0134b0db7fcd6aecdef8fde027d0f632224304fd2d76e426349351b5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac2648d1f0efa0d4ae8480ef945cfa9c213a60140d9b1e213b9d4bdd24b4767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e7657c41652f6fabe7a8ad86615d19ffa2fdc56032f9b29007ee71695ffedf"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
