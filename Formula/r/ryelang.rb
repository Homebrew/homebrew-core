class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.99.tar.gz"
  sha256 "dd99cfa0d3d9a612d29f0adac2e5db1d608b7309582f8854414fc025fe5a837b"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9ec2591d5a9c4dfb999fa4f8374704fe4b5545f79555816bf902f572d11a8b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5211d483fcb303dd3457d13fb125ad8fec5c1e4055d70743900a32090db1ba3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aaac78cce13c6e176951a1d270da01a9728d9531d05aac681bf8d4d894c02ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0d1a587cf12a73c4001d2378f73977cb09d65c2415aa862a9ccdfbf1bcb2f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6205186f153a24c11b47b213a04be0ddcf84abcaf697130271089e4d67432080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecad3b1be5a76b358812b1c26a40d0fe44954e83d31f799d4884e3188f0237d"
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
