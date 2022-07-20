class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "cf9b4a8a040dd97a483ce45a6ceda729faec746d38ed3b60962bd9a84db5e5b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce72848c72b1e65d824ea8c08503341b8f3cbd46bf5932eea7e7de0744386f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4de5b6855500c28ad9c5dd10e83836b784f49d4f904bc85db484d7eac4d307ac"
    sha256 cellar: :any_skip_relocation, monterey:       "92de4a3920771d27cdd5818494e996954cf610f2609bb8aa1290ec685f6bbb7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "37c18d815859310dd4d5b3f57a829fa50caaed6cb70cdef7c1671a90a264d6d0"
    sha256 cellar: :any_skip_relocation, catalina:       "38088d9ef743af1475601a595632c10722ca41776af80f3d0eabdea067634751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8358d42a8e886a7ad864983ed2592ef5daeb49ba0eb183563141c5fe35ddf277"
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
