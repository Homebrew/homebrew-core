class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.65.tar.gz"
  sha256 "1978105d966210f8143269e8a273425be3a0e6c80855e04da75f4690e63dde95"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1af9dc50c2f185d72fe6d0a055e54c8d17a0c50c2c2df58f55ed4cc7aa3b12b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c2554728a009533e85346317fb405e90f00778d99843da61d54fdfc201036cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d1a9fad06276f8cab492783667f82b1afd7bf1a48f96569e47dc983b5c3222e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6daa4d93372df62043753a7939955119ed23b115222a5c96037f43d9d9b47684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a6299ca7f633f4135e7c023107785f0a9240fc863540e8ca95091c9ccf0e2a7b"
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
