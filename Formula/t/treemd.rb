class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "74cf698a520ae60eddba6135e5322bb06deae6474b356d69e3b367fb79a86c35"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4c853c29871568e5318b6fde128a325b6e95f0141e1f73715daa2c41f9759bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c5cf6a31c648c53a7e44c13098c242ab5de7d0727c4e2f32f96bd537c53a1da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26a7feb5059189e11020201e2479f6566e2b209247e33256f56f025f1268265d"
    sha256 cellar: :any,                 arm64_linux:       "823039620613b629423690e21a561c9f834a90ff8f1be8a4fd9a49c881b232ed"
    sha256 cellar: :any,                 x86_64_linux:      "f5240248f6514be1c08107a20f4677af459486e8cf69a1df9df6477ea2c33043"
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
