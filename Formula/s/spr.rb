class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://spacedentist.github.io/spr/"
  url "https://github.com/spacedentist/spr/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "a9ee0f3e1c90176841a42f2177a31c83a93a8cfb83bc1507fcb544ff8d997de7"
  license "MIT"
  head "https://github.com/spacedentist/spr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8989faccafce9c9bf1eee5eeb1046a18729f9acf67fee5ae16b0110f647a722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7a6c8485777c09071c197c7d6c31c4c98b57f4bd361e0f4831eab09329a13f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77f4725d61aa4e91a3ec60cd66e00e8c2eb9409060d21c83d0eea338616ddb0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "253cba645ac75e32a4fbb89e7f11ef64184bc188ef15a003bec6a3ad00bb4444"
    sha256 cellar: :any_skip_relocation, ventura:       "0979ef1eca05662b37d9e6b7d4c6ee19dabe01a55108afce776691679077cdb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91992bcf82d184425bf81988ec78085ec78000e08f70370ed58f2c62ca3f3691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2be9247cdde1ac0abb84ce96ba8536f6d22cda94df4b66636e5a9c4ee7a1625"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
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
