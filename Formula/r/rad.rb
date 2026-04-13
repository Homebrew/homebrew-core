class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.dev/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "7d2215d596fdb6d380761411bf868b7cd451a436efa6dd2153265a7b981e14d2"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2ddfb5f50ca27fc4156adbb4f0471db7fc13e095c89fed1eedff83b73b9d00f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2540fee7bd9a821e8d7517251bca660e70d45903e5b532006075a117895c529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeabb7881604b0120ea14212ce0f59ed14d683d1eb34ed6e5c96f7c4c42e4916"
    sha256 cellar: :any_skip_relocation, sonoma:        "d03526abced8126bef2552e41b96b53c94880b6bd98aa51d86cae03c2dc55f43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d976118e06481472a02d25be38663c68952ea98bf91b17994e2656df0a1c177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6fc540a6569f8ff546413f349981c20655c466a5046af788472f5fde37679bf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"radls"), "./radls"
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

    output_log = testpath/"output.log"
    pid = spawn bin/"radls", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Spinning up Rad LSP server", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
