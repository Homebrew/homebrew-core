class SssCli < Formula
  desc "Shamir secret share command-line interface"
  homepage "https://github.com/dsprenkels/sss-cli"
  url "https://github.com/dsprenkels/sss-cli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dd8232b11d968df6f1e21b2492796221a0fc13ee78d99bc2e725faf11159798f"
  license "MIT"
  head "https://github.com/dsprenkels/sss-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17aa2621801ef6f326675f97f014800f760ae7258fa1aad314a35489f43b1ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10dd0e8768b42070c548e1666353af62048beb03bd519cea52dce9feb6a074ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35fbdb7b506adde1717c9bf75db077a831a95a9a08e92eeb950fbc2b173a3b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9992233773901abdcd62734c40e52b7ba3c46f268875e571de4577e7ea22a43a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48ed1627955117c7b60602aacc0d94f969daa207be3874b43f04ed007512f7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a51a5e5b66359303bf80381c1134ca4daefd5c785a4bf1b3b5caeab9e351be58"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    secret = testpath/"secret.txt"
    secret.write("secret")

    shares = shell_output("#{bin}/secret-share-split --count 10 --threshold 5 #{secret}")
    result = pipe_output("#{bin}/secret-share-combine", shares)
    assert_equal secret.read, result
  end
end
