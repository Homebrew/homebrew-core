class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "10b4a849b028e8eb3087414950e14cd8ac0521bc6cee4d606a08a209dfa04749"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78547801ee85a557c9d36d8c7f92dc6444f0d9a608562ae5cb9084ffeb61d8b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e181e00de402384a5379baba598d51dab7f1b164c31a2b46afa57e1edf1251c"
    sha256 cellar: :any_skip_relocation, monterey:       "af4d2c82e3f1ee4a47c2ee4a92c96d51ab8a5d5aa3ae6cefa33f9265dfd1e40a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c12f40645914cd113fadb76f174e609004a5d366db45ff66295f73311348e678"
    sha256 cellar: :any_skip_relocation, catalina:       "5af3b52992d38c8f9a6db1da34143b106a17c96186a33cb00782b9486abb129b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90c29f8b80e630f73bc8938196961bcee47cd87149dcb44c4ce9cbd121b1ec4d"
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
