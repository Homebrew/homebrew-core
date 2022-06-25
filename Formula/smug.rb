class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "2659e312fe49b3129c30db6a72191ad986c900c1f8845b7bab1d09da45be8a4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be5b50f1807c0a3c0ba208adf7cd84fcc96d18a790158de61da5d28e2513aeb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a09664dee3ba55e5ce8c554e986b5392c65a9f95161c5f345a9964d0b16e24ea"
    sha256 cellar: :any_skip_relocation, monterey:       "f9718ea13ed35a841eb250edd546d562ffffb28e0cf7852bb843fa3199283995"
    sha256 cellar: :any_skip_relocation, big_sur:        "61c2351c9adb55cd7236ad21dc3054c17a7003fee9e11ab625614d81e75cce48"
    sha256 cellar: :any_skip_relocation, catalina:       "506b711ed590fdbe3ccd137913fefd30f2a634720569a2199452bb85d2267534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a19b23268c6bf9c68df8aa6af3c60292c60201abf50cc403cef6e73bf09846"
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
