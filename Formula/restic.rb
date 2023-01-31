class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.15.1.tar.gz"
  sha256 "fce382fdcdac0158a35daa640766d5e8a6e7b342ae2b0b84f2aacdff13990c52"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcdcc99125f289416a3eac16cceb5f200015414932c4be157229fd1f694db2b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcdcc99125f289416a3eac16cceb5f200015414932c4be157229fd1f694db2b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcdcc99125f289416a3eac16cceb5f200015414932c4be157229fd1f694db2b6"
    sha256 cellar: :any_skip_relocation, ventura:        "b79a7b60206ae079217c7b8bc325d17038d171a768690f5c1ebddf51e724f48e"
    sha256 cellar: :any_skip_relocation, monterey:       "b79a7b60206ae079217c7b8bc325d17038d171a768690f5c1ebddf51e724f48e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b79a7b60206ae079217c7b8bc325d17038d171a768690f5c1ebddf51e724f48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124b5784632abd1c5c30ceb149963b46a0f56eb02b4f41a5dbbd614411b0faaa"
  end

  depends_on "go" => :build

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

    system "#{bin}/restic", "init"
    system "#{bin}/restic", "backup", "testfile"

    system "#{bin}/restic", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end
