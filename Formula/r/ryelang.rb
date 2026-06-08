class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "941741a135e66aa9ba3a39f9fe5503159254fe19edb8976e7a3231bfddb17b92"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0711c4980e20dfea70b6bc3a743f2db2b5caf17c205363539ac639ff47d7e526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b273451d67824fa2a8a5f71c2e4f6f508ed0e45606e69845e20d01741f1380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ce72b4cf34a31a6267ab21da23b52598f0aa94898a2feca9c380b2d79a8b9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "23e2fe3b2ef75e83d015e9a240789bf07161e877578db9e795f7c0ce6a3de4ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e089e5688c1d36836d59ec3066c5caddc810d6c9df509df8d6e63d63693893e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6e6a22c08f2c515f859f6a8d2e90b969ea06a78560f7889e0574113096c00b"
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
    assert_match "Hello Mars\n42", output.strip
  end
end
