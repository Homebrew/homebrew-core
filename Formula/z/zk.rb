class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "ac4e1744655bc5c42caf132ca667e0d882dda2e05ba08762f9f49dd784bec115"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1971a61ffabe5373bc6f702724e11637e09be825d0a2cd681b65569a685b7f77"
    sha256 cellar: :any, arm64_sequoia: "c499482cdc173715708750ce76abdbbb237a7a8560f3f7e3cd5d28e2718cebf9"
    sha256 cellar: :any, arm64_sonoma:  "59250e660fa7b8684e0f423689891c6e1afc204b3a7327c81f4b76ebcb6afb84"
    sha256 cellar: :any, sonoma:        "a0c337e067e1491ebf19f3684bf6e97a02318e2618686153f14bfdece4d6ba2e"
    sha256 cellar: :any, arm64_linux:   "8b20d3a7054bd2e0fc4cfae836f3f159b29eea5a3a4e18d58591cb68a57d840e"
    sha256 cellar: :any, x86_64_linux:  "a581655c423fdd954a8d16cfc75b4ce2ff4c344ecb44cb9e0a33818d258039b2"
  end

  depends_on "go" => :build

  depends_on "icu4c@78"
  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X main.Version=#{version} -X main.Build=#{tap.user}"
    tags = %w[fts5 icu]
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zk --version")

    system bin/"zk", "init", "--no-input"
    system bin/"zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
