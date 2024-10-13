class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://github.com/spacedentist/spr"
  url "https://github.com/spacedentist/spr/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "d1f53f4222fd9916c9edc0457bfe04bac66d9ff60a7c0e7a0c4519317c3f3fb8"
  license "MIT"
  head "https://github.com/spacedentist/spr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0eac58b3ff05872197f7abac423d42d87e439ccaab7f6579edec222f2de2710b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b69a549a251230cd5561cb9df78d7dec8393f923ffbe1379e42312f79ba7afac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5991317f779e5cc3ac6287f08414a51566d08ad837d87fc0fee579c7bf2eed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf35baf53290180b7f1b0a7b453e060eefd982008c8750d1cde5f5e4a07fb04"
    sha256 cellar: :any_skip_relocation, sonoma:         "817a28b41cdab633e17b0ab7ba58be93f1866c15b47a64dc7bd9bff36d1c33b7"
    sha256 cellar: :any_skip_relocation, ventura:        "a68d4e83af3fa0a54f23a27edf699d27b7b2514e6a4b2a631b772728fe8fb4c1"
    sha256 cellar: :any_skip_relocation, monterey:       "6f56e9ebcef926ce71fe573640660366d923d1ff407c26c52dab11891786dd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d1aa332e5b30c08f8d1eaa2aa49a5371ead75d9e5061c6fd822d5a0c70f972"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # rust 1.80 build patch, upstream pr ref, https://github.com/spacedentist/spr/pull/202
  patch do
    url "https://github.com/spacedentist/spr/commit/ed450a3ec9c2b79e585ff162f0f3bd2fb2be4b00.patch?full_index=1"
    sha256 "e1b7dab848c828a704ceeff2e46511e17a16198f26b184f75afd8bf0f695d22e"
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
