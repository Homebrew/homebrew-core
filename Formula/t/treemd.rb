class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "3a1934043642dc2751e802dc66ecdc435d649a9eea22a0b674eaf43d14968849"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ccb981eb5ea7bcf113893086d82e4567e74a67a6dc357b7dc3b177098acf64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de874544ca412a384585762ff2025f2e9b622fe71993d0f99ad43c6c27d8ad34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c29e46b851ef6a5ee1b7f406807760102c23c7233fafd19ff358e32c0dfaf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9e282def9fa031063a6bb7708c5f50e827ef7b8979ea807cf4cc0c5421dd437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebe85f3617cccce7acc101683652e4837bb88fec1d078b281566f3490c60498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f6d3c5cb2a04023309e3e17c37fdec985c1ea88a175339cd2e5a034fb84522"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
