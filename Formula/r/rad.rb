class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.dev/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "dd9e76d37f9f99f500c037ae1631c58b83d0ba60e96c587b90a7434de7dddb0c"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3203254b7a4b9c98880bf5ca8f938b8cc7890c13cfc6c23f6dd8ef42d3d7b9f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8193e7675e167c3e5ffacbf20d569e446141aca9f00515d0495903f6ef40a41e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c715200a45485630e075743e079e93969b0cdd8e63e00790cd3a5bd1cec0df9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73213b7a0a76fa4391e4d4becfc37afc0efd8f4039897213dd0b4cb2709755d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b693bfd935fb3d5e7535e338e50c8c0cc2058f0ccc90da572f85b69e0b4e8bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a387e44ae1a68ffa0386dc93fff20e0324dd3b0112e3b915e776a87b115182b8"
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
