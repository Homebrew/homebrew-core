class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.dev/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "db6d974c777017724272f34e6b1221746bb850c0859443b9bb9337e1dbcafc1d"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb296a183ab58ee5ec13af9d735651f12d6033615effe7b6d7800fa71b209dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8419fba4cd5a145380279f6de6d7bc2f1e7f5d78ed7a1637d2eec44282dbf04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049030a4e8812d08e4b43cb20479f4bd172b3d6fc87596164afbbc2ec6f95638"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50c411c8674f5005d3fb82c244c882efe26bdc69dfd885bdab221dd0486923a"
    sha256 cellar: :any,                 arm64_linux:   "b836b078e119ee2a8d6cdfcd3276c51ae72e10c6fe68f4ccb88951f7e1ee6dcf"
    sha256 cellar: :any,                 x86_64_linux:  "dd35b5d45b4b11867fc5bc47bf11137359e98d75d08a29fb1b8434cee2baad67"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args
    system "go", "build", *std_go_args(output: bin/"radls"), "./radls"
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
