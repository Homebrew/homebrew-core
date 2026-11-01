class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.70.tar.gz"
  sha256 "a72817b9184c4379d8b3c012f91e3f338072b4c8c562b43cbe7aa8fbccb66477"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcd6fb98baf16dcd182413ea80c36529f661aef1268a9e73a3e92a9f8b3093f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab07e284f673284557c8db0862e7d7c0bd869b47e12100fa647fb7533d4cc0f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f42bd230d94c92e082ee9ac4d402ee1c705cfc5d71e864d5928cc278776713a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "613be6234a5e074104375ad3559f8c16a1fdebdac85f6d2cb59430d7e012ad01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "54926e12921da6783cde5c5d86cae9b712c75154315b266a10110715e0db78f3"
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
