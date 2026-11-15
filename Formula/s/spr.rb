class Spr < Formula
  desc "Submit pull requests for individual, amendable, rebaseable commits to GitHub"
  homepage "https://spacedentist.github.io/spr/"
  license "MIT"
  head "https://github.com/spacedentist/spr.git", branch: "master"

  stable do
    url "https://github.com/spacedentist/spr/archive/refs/tags/v1.3.7.tar.gz"
    sha256 "6b48524abfecea16e0e7a131f0c44027375a80577cde43355f54928c4921ed6c"

    # Backport only the openssl and openssl-sys version updates from
    # https://github.com/spacedentist/spr/commit/b930e4e3308ddc67bdc1ebb63385935ce4557e83
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "402d5523feda2e6e2370582eef83d31bf22a21bf7afad9f692a4ba2f894554bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9c8d24a6f722c177614b872ea6bdc77b8ac486cd41f62efe3ccd8e87a352074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05ae7e78476ea060c0fdf2c9834daad1b79920d797e0e4c4ebd33eab985ace25"
    sha256 cellar: :any,                 arm64_linux:       "dbcb37d6a3d9f375757f1f43099bdbebd874241a0b36d7f0c98618ad272d076d"
    sha256 cellar: :any,                 x86_64_linux:      "8c7a06abc6ef0e24b4c244fbb6491f629d2b78ac304ba7f6d0650dc37ec65a17"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    spr = bin/"spr"
    assert_match "spr #{version}", shell_output("#{spr} --version")

    system "git", "init", testpath/"test-repo", "--initial-branch", "trunk"
    cd "test-repo" do
      system "git", "config", "user.email", "nobody@example.com"
      system "git", "config", "user.name", "Nobody"
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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 8c84df7..3e630a8 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1160,15 +1160,14 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -1192,9 +1191,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",
