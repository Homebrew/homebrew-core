class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4225b301705574bfe3fc8c018f2ee50ceed4473ec1091eae5d63891541b2104d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50a2c540cb2d8280c10eae95f80e13767e583ac3a987b0867f0414dd7132634c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b22f7086f3320b42d76efb9609963db43477c6f4e4519f25f27484f76d02b5ce"
    sha256 cellar: :any_skip_relocation, monterey:       "a320a92874484a5c3bc64bab4498edafbc1fc479c7740e2daeca91e2e760f245"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8021655b94f4cd5fed50f1d9a8b59da3209f0e45a0eb014471304abec77e483"
    sha256 cellar: :any_skip_relocation, catalina:       "cc0e58980b83184a537d73abad8d5b37a7e609aa7bfc4a2942d85807f3e89610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f1c7a328aac7ead269d0afe378bcaa3a960a315a3d5b118177d932aeede39b"
  end

  depends_on "go" => :build
  depends_on "tmux" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"test.yml").write <<~EOF
      session: homebrew-test-session
      windows:
        - name: test
    EOF

    assert_equal(version, shell_output("smug").lines.first.split("Version").last.chomp)

    with_env(TERM: "screen-256color") do
      system bin/"smug", "start", "--file", testpath/"test.yml", "--detach"
    end

    assert_empty shell_output("tmux has-session -t homebrew-test-session")
    system "tmux", "kill-session", "-t", "homebrew-test-session"
  end
end
