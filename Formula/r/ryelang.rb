class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.89.tar.gz"
  sha256 "d806453f84d22fa7f7a4ff5592d2fef869ea100ca06985d6a12a9ebec7f1cb25"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cece420ddbd2a389b038a79849adf9f91fb68439fe5663474b50941c6bf4400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be1f2c9fdff279e2d23adef5b1c65790142e83fd342721ad09655e59513977bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b7c9d9f8ca85d7261b6c9ce74908b2f767452ec793ec9709df55ea7c209238"
    sha256 cellar: :any_skip_relocation, sonoma:        "c434f84cd37f770b17c8da92fc475e4438d3dba880567aa7c2e56b74edd425bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae517b65edeb401a2364d31750e76ce88c3c81e17a93882162ca54c08df27d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d566791e13414548176482563b8320e85f84118d7ebb435c81347ea76efb1b0"
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
