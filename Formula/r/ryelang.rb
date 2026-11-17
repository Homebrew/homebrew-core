class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.82.tar.gz"
  sha256 "5f6235856eb7d8c6ae42e59d3f74144b5830a48888d012d69a970bc1de655bf9"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b48640cf35c6ce387b51d6b9ad0b6f788b072ee2c2a53d5b60d8e89522b4469"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09decbf3a7d7945c2323aeb618a6962e272b43bea9fc80d4111747b46292716d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cf577ad8bad2e50c3ce277a6beaa0d5da6c783be9f0f28a33e74be6223609c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd68fe35301235c100167d79526b9f126866ee57b5940bb48ed4972d74bfc132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2b4adb2903bdeb6116fd7850a8dee1537263260c35b167d004c9862b06112729"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[-X github.com/refaktor/rye/runner.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
