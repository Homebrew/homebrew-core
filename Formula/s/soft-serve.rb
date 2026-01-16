class SoftServe < Formula
  desc "Mighty, self-hostable Git server for the command-line"
  homepage "https://github.com/charmbracelet/soft-serve"
  url "https://github.com/charmbracelet/soft-serve/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "c596fbf7a79249d8e97da532ce3e8d7ce06bc2164f880cb1f920410705c49eef"
  license "MIT"
  head "https://github.com/charmbracelet/soft-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c162cc14c9f37264bcd2f418b3733371f3fb2558b408e2c674a71eefe07f24f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42bc0686895b817550b23cab3a1576e65813d0e9fce44deb373f5dbe24d46744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a9814f583370777910e42d4be456bd7cfb93c45126c8c341964eade5d9bf83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f7e1dea19446039d393967962187d85bbbcafaa222c11d9171243d519bd546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cf4b654c6fe9e1b96d730f579cda85129993aa810ac6b791e5583c1b0933bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770b55932c1ae7f6e57935f203b57c47884de13227c423ee51c491cbb1a71a8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"soft"), "./cmd/soft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/soft --version")

    pid = spawn bin/"soft", "serve"
    sleep 1
    Process.kill("TERM", pid)
    assert_path_exists testpath/"data/soft-serve.db"
    assert_path_exists testpath/"data/hooks/update.sample"
  end
end
