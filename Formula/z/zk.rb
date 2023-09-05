class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bd96f93d50e2e72ce05f36c3dab5b7942ae205756f26d4c68ba2a7ccc783abc8"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4971122839654adbff8642e44ba166117cbb09f53a4ee35cb3bd73c1c32625dc"
    sha256 cellar: :any,                 arm64_monterey: "fa87223acb14ee1d33b5493498b19380b0b4a94c3bebdf2faa64e0bf3335026e"
    sha256 cellar: :any,                 arm64_big_sur:  "ba7dec1077c88ec64205cba25cdae02518ba69507ee9acea84358a130b25858a"
    sha256 cellar: :any,                 ventura:        "a1e96b6d47ff1ce7316d12f0d659db84885c7b9c9f752186d6ab875d78884f2d"
    sha256 cellar: :any,                 monterey:       "83b294c1fd7da4e5976129741a8abc9d8fb8d8a96ddec7d4d8e473b2c79d0720"
    sha256 cellar: :any,                 big_sur:        "59becb9aa1e9296c69a713b57c2fa4567170bf00fc0c77ea2b33525be8d90f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e8999c69b2a43d1ce03a54a0cc2c6cc87e2741419c9bff24d96b4fc9075afd"
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
