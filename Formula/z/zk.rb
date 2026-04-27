class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "3cd5b011db7b587fd53d99040d117b3f52f0dd8524bae2a35bc9ea4b9590e754"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08ae14bc813dbe936a28f718cf824ca62910e343715ad235de22028a85494e35"
    sha256 cellar: :any,                 arm64_sequoia: "c4afd7f88822fcf11acf941db0ead0c0caaf03d3dfb38cdbe0829e42e3970738"
    sha256 cellar: :any,                 arm64_sonoma:  "664d76570aed0a86cdfd7c560909a19e8b5ceab238eb146cd52cd73e70c6424a"
    sha256 cellar: :any,                 sonoma:        "8e9999f5db8e1ad18074128a86c59e91807f36940c9aaeea8b8839826adff776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c131960637949a35630c79466a71f02f8a790e9bf82428b5f47166030bfb719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df1b3c9f1cd0dae68b82af47ab7f4d853b92e5a127a78cc9230e1ac0610d381"
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
