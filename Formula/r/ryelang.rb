class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.80.tar.gz"
  sha256 "fb4fc8808daaaa27b5e44afc4adb709ea604d3100b814aa4d7bb81495cf71d3c"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9162961dd8e98c177ff965d63d354bb7bd7895601ab87cff1008f09bbc5c8d69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87d97db5e70afa1e81b9ee2aaae5d1caff2f5368499f3a85a98eb75168d8a15c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c4359c97978bb1027627e98317f8ecd336e8bbdad3f5208f5a5bc75e7288292"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a97571932192e13c73529f0505d5f30b51acee4df7e9fc9d53463f7f3c0cd475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "31b9e76f135859a29f4badc61a9b599f9ac968badc3809d14019f10740bd12b0"
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
