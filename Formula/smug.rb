class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "ec72748a8425b0aadb65cb1d5fa956b33258a29256583c635e07caba440a0788"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3035675211a0c82ed566573df01fa2c23f5ccb44a77eb338bcb41e167ce12f8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad559a52f54f9ed84601bbb6e563d1f415880880cd969e88b209351c2128fca3"
    sha256 cellar: :any_skip_relocation, monterey:       "bd47ab8f577c219df5c1f39c42b98c105b02b36356519e44b2499f922314af21"
    sha256 cellar: :any_skip_relocation, big_sur:        "77ffea790e36ac16ca2835dd17d58857e916bd58f104ee0701f7a7af4a376974"
    sha256 cellar: :any_skip_relocation, catalina:       "22e4404ea1eeb196143642e5ab789a4101a9d7a66d63e3f3ae55004ccc15a214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c492188f01dab148da458e79f6d5d4f4089a2709791629bbd38722646365270"
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
