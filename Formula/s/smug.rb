class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "c398b2d7094cb961a8c8f42338b669462d4f2413363ef704d10fc004fceabb02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f27c6f9c94d78089203eef03cffad372469da86999b5ada164cfd24b3809e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1bf817ecb24dd75664860b906815595e7300a0983d4fef6d5c712c69ecd9dcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1bf817ecb24dd75664860b906815595e7300a0983d4fef6d5c712c69ecd9dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1bf817ecb24dd75664860b906815595e7300a0983d4fef6d5c712c69ecd9dcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c0f3f6da2ea72eb42b1c70b9097c5711405ea34e5b445f211d5ebf1930e50b5"
    sha256 cellar: :any_skip_relocation, ventura:        "0c0f3f6da2ea72eb42b1c70b9097c5711405ea34e5b445f211d5ebf1930e50b5"
    sha256 cellar: :any_skip_relocation, monterey:       "0c0f3f6da2ea72eb42b1c70b9097c5711405ea34e5b445f211d5ebf1930e50b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "909c57aee9501f38fa537ce3b6a1519bd1bea0fbaa28e16af77aca8ff36630fe"
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

    assert_equal(version, shell_output(bin/"smug").lines.first.split("Version").last.chomp)

    with_env(TERM: "screen-256color") do
      system bin/"smug", "start", "--file", testpath/"test.yml", "--detach"
    end

    assert_empty shell_output("tmux has-session -t homebrew-test-session")
    system "tmux", "kill-session", "-t", "homebrew-test-session"
  end
end
