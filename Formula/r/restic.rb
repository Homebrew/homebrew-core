class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7def5bbe05e62640f7b030b865b6f304701fd876f7836f5a6a603b56e1f4e30a"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    manifest_sha256 "9425afa73c708884c13b9287b346cd5d8c3bfbe57fbf77169393d5a1dc1f775f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06f0efa7880f0985036e2ae22b3f307475a822ee1b90ea2d7502eab2cf246ed1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06f0efa7880f0985036e2ae22b3f307475a822ee1b90ea2d7502eab2cf246ed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06f0efa7880f0985036e2ae22b3f307475a822ee1b90ea2d7502eab2cf246ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a395e26058cb6397cc5bd853662f5a4758bfead4d65fa9819e5a454760625a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "82e9a5e826b02fc067531febab44647d39f77b3b1b85b4e2926dacf9518ccef4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "run", "build.go"

    mkdir "completions"
    system "./restic", "generate", "--bash-completion", "completions/restic"
    system "./restic", "generate", "--zsh-completion", "completions/_restic"
    system "./restic", "generate", "--fish-completion", "completions/restic.fish"

    mkdir "man"
    system "./restic", "generate", "--man", "man"

    bin.install "restic"
    bash_completion.install "completions/restic"
    zsh_completion.install "completions/_restic"
    fish_completion.install "completions/restic.fish"
    man1.install Dir["man/*.1"]
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system bin/"restic", "init"
    system bin/"restic", "backup", "testfile"

    system bin/"restic", "restore", "latest", "-t", testpath/"restore"
    assert compare_file "testfile", testpath/"restore/testfile"
  end
end
