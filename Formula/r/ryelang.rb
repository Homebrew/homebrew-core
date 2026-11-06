class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.81.tar.gz"
  sha256 "6de3fe3abd5f82a71808eab9c4debfc545c42f1ad7366a0aee1effef1755a6df"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0afb9966942fe4177f1afc5a61680d3d98752bb99231fb04887a721dc648d2c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "030901ed58c291c9904b31088ec651baf1e162aad2b45ce3a9e37ecf9f80714b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f96170e2ff857f3569ef48a194a12f8a4e80f4ed4dd6c8ab7b3b9a417d9d4d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0adffec38d62a19b96408339f4f245adc7be9bedde98a8b0088950e220ecb961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ad9ccde5b2fd0190fbb416c63eb82f92f92a4482fbe7131a931b606ab33fb6e"
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
