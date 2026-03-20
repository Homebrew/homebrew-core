class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1c602c9d5a186529812b8187dcb23efdf07d1019aea2b9335420ac2c8e82a81c"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa78abdd8f6c06e4d5ec8debc055eaabd6917bfbaa73bab51f18bb2257200cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb3d519f65b50280d91421360bd672ff4b6339e4850b4df001fb2a002d892de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16c57f8cfde3bbe14e77730b75c5e9e10c115a6d0afcde3da2421f529015f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "717f94d2e6f18b9a3444153c8d50350a998712b2886d7e1a3964ccea6fb7145a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca2bc7cea9702f3d1bfec1b008817cbeadc840d3d728c83e33ac434995aa7d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f07f9ccde40bd9cb5836ed1fdbafe2960ae1913982d4c95c6d63d958bc58c73"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad --version")

    (testpath/"test").write <<~SHELL
      #!/usr/bin/env rad

      args:
          times int = 1

      for _ in range(times):
          print("Hello, Homebrew!")
    SHELL
    chmod "+x", testpath/"test"

    assert_match "Hello, Homebrew!\nHello, Homebrew!", shell_output("#{testpath}/test 2")
  end
end
