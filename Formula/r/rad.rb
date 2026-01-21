class Rad < Formula
  desc "Modern CLI scripts made easy"
  homepage "https://amterp.github.io/rad/"
  url "https://github.com/amterp/rad/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "716fd40dcbbfb58fb8c39bd5d65da47383f49ee4f4bdf790af20bd16aab92d36"
  license "Apache-2.0"
  head "https://github.com/amterp/rad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77bb57450d88fbd524a289ffb970f447348f3bc4c1bf38d2c0443cbeebf91954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cefc115bcfb03cf4428aa029c82ee6b3f68e1bf1369d9a7af357d0229629c483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92d9a9397b344498438eff96b55d4a69cdaeec01a8a95f439103c289e3471f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a3238a039825507cba2eecc4297f48952fb46e650fe5221ca6fcc8be5708f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c9aadce617369a5fead9313dd50f5c38206b53f20acf7ca2c41864016eb6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c7db1a1943c76768cdd11661a0223a9a53acb182387dfa93deba3f720b5d24"
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
