class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.twigpine.com/"
  url "https://github.com/Twigpine/zero/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "065a2bbcdce5e7fe597247e9a14fc41cb4ff0577461fd73bea72bc889af4d233"
  license "MIT"
  head "https://github.com/Twigpine/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef61d8450910618a4572c17aebfc373bab93106ae052f0d213c4a4602fb1681b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef61d8450910618a4572c17aebfc373bab93106ae052f0d213c4a4602fb1681b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef61d8450910618a4572c17aebfc373bab93106ae052f0d213c4a4602fb1681b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b963e98b778044e428938b92f346484c4d4135554544a7f84a456e10972cd10f"
    sha256 cellar: :any,                 x86_64_linux:      "822e19ea86f3e0877f191aa78735f2ae69c13e8883bead7e4d680ac3ec1335a6"
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
