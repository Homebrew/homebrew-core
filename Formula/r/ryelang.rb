class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.81.tar.gz"
  sha256 "95e0d9b747f44c216cd084574e1d7ab83428e6d84c3baba3aee0133a5988e8a7"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad49d5bb66d84b1aae60b31b3cec27dbf854675ca29e3a8449a4c7506e8779be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc42a012fa02c805dd960b54c3e7a93b5e5620f07afdb21ad1254594596aeba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ea69c42fb3de4913149dec330aba0698b5b8219b49fb73adc70725b985d1f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d4fa03f8267fb2c06f83d88cea68b11c96df6afbe587a01918d16b8d46ed27"
    sha256 cellar: :any_skip_relocation, ventura:       "1ff7ebf5900910f3c238421406da6d1d7cb903201fdfddf40fcacdcf7b7502ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031308d0b340b0aa1520b8553703f1d626ae348e443a24cfe4aa047e51c2b76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97e14b78f23d3099edd2b40d157884f87d0312e46e32d8a0fc196a39d83c3073"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
