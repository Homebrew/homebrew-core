class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.dev/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "feb31c9b8bb767c868cd67cedf52fc0fe609e549e835978f5c565d1432fa8167"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdab8393f40429d426089621f8eddacc20f1f184c1c40bdee34b558e2a134558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5a2edfefc40db6aa63ac69f886bedad3ea579190012265ca759cfd42f71f1d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5305c08428da3fd4fcfcb0741e30287d064283e801e2b38616d0baee8101857"
    sha256 cellar: :any_skip_relocation, sonoma:        "9924c0c7f51572b1845268764b03cc8075974427b895a852ae09683f91e8da93"
    sha256 cellar: :any,                 arm64_linux:   "88695d1cdda87fade5a4fa2b9d8520a9910f1deb7527749872335f833e1d922c"
    sha256 cellar: :any,                 x86_64_linux:  "4b9659ba4c16449744e739f429d85737e5c48665fff5e56ea19a4f1f86b3cc17"
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
