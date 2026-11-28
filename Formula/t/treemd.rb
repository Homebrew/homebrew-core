class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "9808666913e3698eef1372e614044678a32ba7cdc6da514080c442c12ee3fed9"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    manifest_sha256 "ee424d118d45000cbaf6709c3f74fedfb0c7e3cdec0b1cd95a4cce300987f602"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d501fbf629662a2c7b232db52220b90b1201eff0f8bdf1e9da7c461cde485fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adab7457bf8b506f769667fccb731cddac0c7f7b5429ab1f7cdd635b18566eea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d91b787ba61e5b7b54db108141c01155d496582bff2d952f80bcfeaa9b92b20"
    sha256 cellar: :any,                 arm64_linux:       "12b15ef71fe562c31cf54dc35aa09675fe4839931267c7691dcc03832567966b"
    sha256 cellar: :any,                 x86_64_linux:      "4e3b5f81d64531162749333a482c95c5ad9a06e1450f13cec2bb68d5902540cc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"treemd", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    assert_equal (testpath/"test.md").read, shell_output("#{bin}/treemd test.md")
    assert_equal "# Test Heading\n", shell_output("#{bin}/treemd --list test.md")
  end
end
