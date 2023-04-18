class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://github.com/getcord/spr"
  url "https://github.com/getcord/spr/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "eada48e089a7edef98a45cfa7ba8b4f31102e72c9b9fba519712b3cfb8663229"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9930a1a635480ecbb6c6dc6a05f79058a96e46b3892c1518a86238b263bc7d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53115bf257ae552982f512f008bb7f7f88d13249111d7ed58b3b42dce447c060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59cca6a0a52c53c8c758ba8722e24b52239c668273cdeb89884b9f9964bab36e"
    sha256 cellar: :any_skip_relocation, ventura:        "b80056f73d8861eaa031f4b73e2492e87e409247827f6605ad91c6b0c38abc4c"
    sha256 cellar: :any_skip_relocation, monterey:       "e4fc2f7bab9f2b2d2688e8a92517b07004dec292d8e000b988d01e976d5f516c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d92cfc824a5c4bd30ac14c88fd1147b5dc5c84d560ab8ddb8cbc93694d668894"
    sha256 cellar: :any_skip_relocation, catalina:       "34791a0fc2f0421bc7334137c5a538d4b77311430fbe5167e937ee2c36774a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021b7008382f3b08eb08933c099c347203dd751684b27ff22cd6ac3e9eede534"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    spr = "#{bin}/spr"
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
