class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "cf9b4a8a040dd97a483ce45a6ceda729faec746d38ed3b60962bd9a84db5e5b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ed975430bba5b86330c67ff2bf9b0d27236a1a6ac4a4bc8c18adb5d3d0952e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a357872068ec093f849a60c938019844d0a26eb005946c6e0303743a61e1c381"
    sha256 cellar: :any_skip_relocation, monterey:       "a3136d72b3e04d0bcecbc43c9e5f4dc80db3af9a0759224a50a98b86c0a6d56d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6bce725a76733ec5e8a8b9d2eca9aeb8b8331bdca92a37e2031bce7b5e2b133"
    sha256 cellar: :any_skip_relocation, catalina:       "2f5a7a2e7c6efb36b731db7449eae7f23aa2d9038b762a24242684c1cee041d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4e04c5fca7f2fa2379314ea4d1b4b4c52698f9c4ba513174af28a67112679a"
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
