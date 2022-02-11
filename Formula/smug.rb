class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.6.1.tar.gz"
  sha256 "34fcdbb2183de75c2f725b77e8d64261ab43c152cf2a39f0c97cfbe05c4f600f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "656fa4ac3bea46df6b3e98d7949965d61f5b9930c4fe7a1dbaaad1a96f8b43e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0176d3b1cad3174f2ff360c4b57cdc6e5ac0575e53c9c73387ce234b9a746fa"
    sha256 cellar: :any_skip_relocation, monterey:       "bbb7b973854757b86d825af723f2d4b88ad87e35dc2f6f34be458d0380a11239"
    sha256 cellar: :any_skip_relocation, big_sur:        "43527e1048bd72d1beb68c369a292d9ab9865018085c34bcd7aa2b2b9702c206"
    sha256 cellar: :any_skip_relocation, catalina:       "454884ff2732db10eb9b2a1e2c4ea692079dbda5cbc47a63c4274bc2e420d5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc966ca38ec8860c768966d2999fe9e536567ac4142bca6e8454942ef09c2f9c"
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
