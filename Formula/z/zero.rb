class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.twigpine.com/"
  url "https://github.com/Twigpine/zero/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0a4627c78c2f11b626dfb205bd7977b9a00fa04f07d8df670ebe9d6c0f8bb3d8"
  license "MIT"
  head "https://github.com/Twigpine/zero.git", branch: "main"

  bottle do
    manifest_sha256 "c14c654b2bddc3abbbec133b15818ad5fe6178b3c34437807153304659216b1a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cea39ab4da2815a45e72890c4bfb6e8ddb2d08dc99a05a36d953882aef29686c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cea39ab4da2815a45e72890c4bfb6e8ddb2d08dc99a05a36d953882aef29686c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cea39ab4da2815a45e72890c4bfb6e8ddb2d08dc99a05a36d953882aef29686c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d72e77a048654193442303255e71bc32d9855366b441eeaf4868d384a04c4f4"
    sha256 cellar: :any,                 x86_64_linux:      "e55568d57d833bde6276f969d1b01fb09512241ca11a95d49d8a00c4df837cc9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Twigpine/zero/internal/cli.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zero"
  end

  test do
    (testpath/"cmd").mkpath
    (testpath/"cmd/main.go").write <<~GO
      package main

      func main() {}
    GO

    assert_match version.to_s, shell_output("#{bin}/zero --version")

    output = shell_output("#{bin}/zero repo-map --max-files 3 --max-depth 2")
    assert_match "Repo map", output
    assert_match "cmd/main.go", output
  end
end
