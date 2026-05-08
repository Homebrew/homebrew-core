class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "024b5a1615c8ac1924ec3338b36031c36131bad5de77dcce05adce35659b7489"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1199b12a32b2a8b2205721d7d9e0b1909ee5e7da79e12c6b7d7cee355771ed6"
    sha256 cellar: :any,                 arm64_sequoia: "da9a090f84ad99042001f312c812238d0dfcb8e307b45623dd1cb2c45f502513"
    sha256 cellar: :any,                 arm64_sonoma:  "2454098ebe5d7e54fc1c2b88a07056c97f691469382ff23ad20f247f896b41f0"
    sha256 cellar: :any,                 sonoma:        "f2c54b6ad8308bd145bdc0d302f3f0994c544ec092861546c24b29d5e985f4df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dbf7460386fb6507ab299db1087633d101806834577755f8d01d699c2600da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5614a228da713bdd80367821902b49a5da8563de49d825ab16cad269352d7dec"
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
