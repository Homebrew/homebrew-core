class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.12.2.tar.gz"
  sha256 "6f23549e5f398113ecd0d2f15c829f5ab84fcdf99dde9942c61746e72f990085"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36d0b28c8033e6b2eb40082dee5e5588316f456cf8e34805cc8133b9aa25e68e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "836dd4b7dd3c4ec9a548ad32df52d9cd5d54d3a9f5a75a5b8ec722fd5f37142f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28a6e084ea6d69b4c20b3406fd409ac498cb3c7c05d6c0a3e3ace4e642c52ec2"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e43f600bbff05025c5202fbb94b856934eadc803227345a344d9bce08a91dc"
    sha256 cellar: :any_skip_relocation, ventura:       "d997d0a7e7d125c93db5d221d7bcdd3fbdebee268e80a688146132a4fef7d10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "772768bf07161004287a339a0a9b346534dd6c76c58ade1d6f69a8d0502abd49"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/trippy")

    generate_completions_from_executable(bin/"trip", "--generate")
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}/trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
