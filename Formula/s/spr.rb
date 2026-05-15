class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://spacedentist.github.io/spr/"
  url "https://github.com/spacedentist/spr/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "6b48524abfecea16e0e7a131f0c44027375a80577cde43355f54928c4921ed6c"
  license "MIT"
  head "https://github.com/spacedentist/spr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77939b958880db3631587b135834ebd6a52733fa5800b68dc8132effe1167202"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda7b7bd81ba976da928a79e3579874e455548bf25c954a227748041b8145254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d053d2d87b8b5a46d075854071795c126d3b751f5a58b4a6067952eb2c3dd9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8859772520af8cd0c3f23cd98da54cd1196164ee4f6295cf4efe204c1e03bca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a84d4a3c5e1be826286e82449f3859ca243077fa8c3ae3c74f663090b0062b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff79ed181ff54c4d3dfe9235d356c632d7b1524cb91fdb59e08dbf4ddf73837d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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
