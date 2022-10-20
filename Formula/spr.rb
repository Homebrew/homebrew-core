class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://github.com/getcord/spr"
  url "https://github.com/getcord/spr/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "eada48e089a7edef98a45cfa7ba8b4f31102e72c9b9fba519712b3cfb8663229"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e26da27a1ba6df81f6d797860ba0641c191d6342771d6878281a1cd9e82c9483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68be8c6508cee8c9fced5b1f4fc415d5977f777d4b6f0b015124556efb61f615"
    sha256 cellar: :any_skip_relocation, monterey:       "909c0511aad5756194d666a56e467cd7f672cea40d82cc501c481cb04f73b174"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3aa993589c0451ee2c99a06dfb7595fcf4256149d2400662ef18d7001f549fd"
    sha256 cellar: :any_skip_relocation, catalina:       "e40ca18b54e15a5e15e3356c1683e7ab33f64e095d913dda898e82624a9b5fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6817bc771ea6325e98f733d4e25a6dfda56f35401890b27e6a31c5c53faecaa"
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
