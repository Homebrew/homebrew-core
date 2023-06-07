class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "9d864d71edc31e47ddc18e32f70b579c5e6863e7a767d9ae3167d75467553474"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc3016d43d79171ad8e05c23a0271257a987145782c1efd88c40bb0b8bbe8a72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e3775ed32ea58015f2dd92c2c3bcb91018a27ea1c9c44e09daf5c2970206716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0af8b169e09d23a1fc1c44c9e6c02a2fd9bb902b07b00637551bb7256cda7b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "170a42c8b5c0cb776be3979e0f03336cdc1534e254bebc72cd869740ed1a16c5"
    sha256 cellar: :any_skip_relocation, monterey:       "059b9dc5449ecdbabd67977f1ce687ccc8e1044061dc361a6147af7a91b3485b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3ff2185fd39b6314436d02a2f29832e142d494967435b3747a4b69c843d61a9"
    sha256 cellar: :any_skip_relocation, catalina:       "e4010fa44ea654c03f767a1c36ffed817346e77cb449138714c73770800f0621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34f256c0bd39e632e707b96f3ae4a2720f30bec53bcbf13e9705e1f743a3317f"
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

    assert_equal(version, shell_output("#{bin}/smug").lines.first.split("Version").last.chomp)

    with_env(TERM: "screen-256color") do
      system bin/"smug", "start", "--file", testpath/"test.yml", "--detach"
    end

    assert_empty shell_output("tmux has-session -t homebrew-test-session")
    system "tmux", "kill-session", "-t", "homebrew-test-session"
  end
end
