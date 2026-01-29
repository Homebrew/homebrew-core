class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "75dca31dbb0fb67ba6d6d27bf0073e0a59d3b9a78843fa034ed72c26799f2836"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "457921039f4909611f9e73fe2d7d4685c74466bab4516d881cb121b54159c5c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33d3721a3fd515a47d51c08eacd0b3740155e8e6d8bf4b3aea792b4b3725aeb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2026316c3019178308b64280acf0a9b35300fcac05e3ab3a7f6090aab9849e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb912cd01273df3dc201f605522ffb9a5dc162c5fe6cc1fb88a0d1c336c467ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "563cd884c44e975ce9ffb8141d35500555a89f386e2e4355709cc366517de7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7f6a9b5d2e66407ea93e37817b5b2f58663c0cc78c59f330b63ede45d29785e"
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
