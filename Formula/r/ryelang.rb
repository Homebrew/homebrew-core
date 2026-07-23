class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.55.tar.gz"
  sha256 "f66d813ac67a1822a5060dcc99d31f63f3e7f58c5f9fbb7fb1ca43eaacc461c0"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7e46baaa59abea32a4c0ad6cb9f31cfeee9f49af20be121cf36f0d13adc7eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90953e017d4cffa8fd8cfd148db5818594d6a41a488ba3856ae047adc94f50f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "176eccb3cfc36200c24b34fd85d54cdfe0d4c132383bdb3f4ba7d4df6822ca7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfe651adfe4b0119caa9001f4f0737ca0d730185c59b8af525760d625095fab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40909c9aa76cdfe3f54649820d15ec91402497b789f3d7be0963059467dfaa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "850ce1e50278e01322d164a0f7929744040ffc19299567c9ad598b04722cfa3e"
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

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
