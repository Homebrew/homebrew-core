class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bd96f93d50e2e72ce05f36c3dab5b7942ae205756f26d4c68ba2a7ccc783abc8"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dea76ba6edebc030a5d5239f4419424c1519fe8ccda23a3bf64a8acc211d7879"
    sha256 cellar: :any,                 arm64_monterey: "7ed439e7cb1a98ffb8123235bc657927fc007af5be8dbc5ffa37a669d128c6cb"
    sha256 cellar: :any,                 arm64_big_sur:  "700f8f4556d7b49b43ef3f8b68fc1f11a51b6bd9c6e1d8b039542db0f069e017"
    sha256 cellar: :any,                 ventura:        "ef912631df644a06afc70217a570705d6e06b64d12adbced6d924f48ee65e9ca"
    sha256 cellar: :any,                 monterey:       "ce9199ba18f7024260c5a292bb9b8a49be4fd8a54f091caf3c3d25a6ac308dbc"
    sha256 cellar: :any,                 big_sur:        "523b252953a9346d11a720450275345197e897229313ac5da11e1b299de9fed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0523713d258b463e9ef81ac1009ef36f43225411ba8621fc6cc80b738fad69fc"
  end

  depends_on "go" => :build

  depends_on "icu4c"
  uses_from_macos "sqlite"

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.Version=#{version} -X=main.Build=#{tap.user}"), "-tags", "fts5,icu"
  end

  test do
    system "#{bin}/zk", "init", "--no-input"
    system "#{bin}/zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
