class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://github.com/spacedentist/spr"
  url "https://github.com/spacedentist/spr/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "d1f53f4222fd9916c9edc0457bfe04bac66d9ff60a7c0e7a0c4519317c3f3fb8"
  license "MIT"
  head "https://github.com/spacedentist/spr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "410664abef3b1b365b94d63b796d963b8b0f95fc7396bc1057172b53ee1ce914"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53a073f763bd23c04670ad82ef854ff0df0d4d9bcbb4210f24bd2e1bbccbc6db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b34ebc1f5dcd278a53d31aae1a2e86706ceaeb0c0e129a03ee9af9016e8f21"
    sha256 cellar: :any_skip_relocation, sonoma:         "8305e6d5e45e90c71b91647d4bdda118a0890885c100f75d7ef0d4a1b71e9379"
    sha256 cellar: :any_skip_relocation, ventura:        "27d08142f74458a94301ca05fae06fea6b2273b991195227f472688fa74e839e"
    sha256 cellar: :any_skip_relocation, monterey:       "709fbfb646bc6dc827d6e2f7c604941009801a4891fdf7d307c97166f3e7782a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3749d08a6e871d9a0e68cd0eb667d1e667fe5e64ca967c59a2ee5f72728be93"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "spr")
  end

  test do
    spr = bin/"spr"
    assert_match "spr #{version}", shell_output("#{spr} --version")

    system "git", "config", "--global", "user.email", "nobody@example.com"
    system "git", "config", "--global", "user.name", "Nobody"
    system "git", "config", "--global", "init.defaultBranch", "trunk"
    system "git", "init", testpath/"test-repo"
    cd "test-repo" do
      system "git", "config", "spr.githubMasterBranch", "trunk"

      # Some bogus config
      system "git", "config", "spr.githubRepository", "a/b"
      system "git", "config", "spr.branchPrefix", "spr/"

      # Create an empty commit, which is set to be upstream
      system "git", "commit", "--allow-empty", "--message", "Empty commit"
      mkdir ".git/refs/remotes/origin"
      (testpath/"test-repo/.git/refs/remotes/origin/trunk").atomic_write Utils.git_head
      system "git", "commit", "--allow-empty", "--message", <<~EOS
        Hello world

        Foo bar baz
        test plan: eyes
      EOS

      system spr, "format"

      expected = <<~EOS
        Hello world

        Foo bar baz

        Test Plan: eyes
      EOS

      assert_match expected, shell_output("git log -n 1 --format=format:%B")
    end
  end
end
