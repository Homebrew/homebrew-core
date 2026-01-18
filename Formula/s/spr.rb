class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://spacedentist.github.io/spr/"
  url "https://github.com/spacedentist/spr/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "6b48524abfecea16e0e7a131f0c44027375a80577cde43355f54928c4921ed6c"
  license "MIT"
  head "https://github.com/spacedentist/spr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b808f91f099a130b9e5d835600cc61a995590525ced37b59abeee7aa0fc58b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8679f71d4efb65c1784f2b20c2339ca5032ada6a676e9a082f3720d51b9973ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93212861ef027cc18853c3e18c81f1b68640deb9af7955912fc84549d91e93ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0622a60bd0c8162d2e28d2c85cf6ece553f2e9851913bfcbc64ec3f3376dc429"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e8a7f79f2e9518b1516c8ec695067a3abe5e579428964719f941390176da2f8"
    sha256 cellar: :any_skip_relocation, ventura:       "30a12a3e0c4d6db8deb8c30aab2d12380cd9cf1fe867cb59620a98355d008312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1004ec8ee05fae9e9b5f59ce37a11006c0433f4738fbeffc192b158d1dbe498f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93414490bf24e6c0a341225a106c4051182c553f5eb7419ea2ebd5cd959198fe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
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
