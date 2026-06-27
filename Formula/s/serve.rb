class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a557da378ecf66d34585542b365daf6e35e1e926452f4bb96f6ab1b151c66e0b"
  license "MIT"
  head "https://github.com/syntaqx/serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20f905bcb40868152269a0d134dac246557d0e9860ce6f0c47e5f769d24a642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20f905bcb40868152269a0d134dac246557d0e9860ce6f0c47e5f769d24a642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20f905bcb40868152269a0d134dac246557d0e9860ce6f0c47e5f769d24a642"
    sha256 cellar: :any_skip_relocation, sonoma:        "eadbc704bb266fd7da9459b77dad9dc59b0e2145328cf344b294ca11a5d92238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb00fce358a6a0dd07a029325cca6abf5a1ad79adec846e5ecf85c5e905da7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8df586110143308c957a2d99e8324fab02ab72e95180bf99ce7e2ee73e6c7c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/serve"
  end

  test do
    port = free_port
    pid = spawn bin/"serve", "-port", port.to_s
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
