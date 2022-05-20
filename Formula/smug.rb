class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "391fa8b6a427f7bf3f98669222ad0053ce8dc237bdb67bf2cdee0ca2f4597b8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b595cb41713b1aa936bfa3a625ff7abf726392ffabefbfd74cc8acfbc7c16c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e315bd394f1f1e5f5d1302f0d765468d4df49e3b3f60573d3be40c58c3265bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "7a6414a89dcaf3d16bb40afbf0f5f84abcec3449f5ce041bee28201cccfe7803"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5061a97af3cdcd0f6e8ef2462824d5681a1bf570e33df1597cbea33af1de72a"
    sha256 cellar: :any_skip_relocation, catalina:       "59a63ef9ce2623af8e56997e2cdc7de1f3b19116252dd2111c173d2aa951a458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e634ddea54ad5fddabbb74b04aee7321687d06630fead24148833d759469a3"
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
