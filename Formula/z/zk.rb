class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "cd8524ea3be81784336706f68edaafe9b4f21d05e0d7a968065cf685e9afefc1"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8dcfeea647d1c853a88db6aca94bd52bce46e25e0f7f02c8b06a1e56d0977137"
    sha256 cellar: :any,                 arm64_sequoia: "dd10021c186a3888dfe0e160efa44871073b8c3d84b576c0315e34230425868b"
    sha256 cellar: :any,                 arm64_sonoma:  "574126a345693003d690cabb40e5fe1e2ea0bac2980e2a2a1538a307c45b33cc"
    sha256 cellar: :any,                 sonoma:        "c7ac813e8998a93474c1810e88ac21951fdc0287b46dda3683806ca2d61feb45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e8d88d343e2003fb8fe1968a6221b5f8e30faaae00e3560841737b0bd09fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa97855d2b7197753f4096ccb3a358b37503bebf031fca8d59e2df663f8fa1ae"
  end

  depends_on "go" => :build

  depends_on "icu4c@78"
  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version} -X main.Build=#{tap.user}"
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
