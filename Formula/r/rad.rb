class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "75dca31dbb0fb67ba6d6d27bf0073e0a59d3b9a78843fa034ed72c26799f2836"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d8ee8452b0bb02e22149812ae750afca15c96a3d66281e7c46a26b194b0ed8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7509cfda16190713d28fad235607bd98c7346ad34ea1f359d264f0a983b2a804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61431e87fe97f7000ecbdbe6d56b06d0e345b980a27d8d74730a35b3231ff62c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4280d4c601b7fc7f0eb662730c712124755ad7540ac67a4486fa012f10ea4113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c27f24e3f637faa120f26fdeae4156606f0927dfda58bd6d1a6208179b0041e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4935c8b27ed127b885fac20bbc55ace8758d20fc8d4175244670903db8c0be8f"
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
