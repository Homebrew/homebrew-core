class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.dev/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "24d4443b1105d69dc991b0493ea766f7b40e8976639938de6a995d64190e9c27"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f98771d3bbbcb3c833ac3f71ca4efbd2318f99eb113c1f1ea53b1c0ec7af265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "962431d0868fdf35589100676b3f2681d2d822a00f41694eca0165faeb83d418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f0687c9eb4462b84d99d06ba1996e5076f33b4492166b6279502192cf630663"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc1b57dee979e5df768bcb6ca721fb364f98c4843a00246b300042267e55f52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3338561e1bf53c6c65b6e283fe31de16672207d0dfd0d9a32f2d33718bec2723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a26dd713cab0a87c4c8b4e9f86a322e17a5e60a96c4092dc59d3c804c9f5ed"
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
