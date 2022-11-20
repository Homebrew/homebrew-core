class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.14.0.tar.gz"
  sha256 "78cdd8994908ebe7923188395734bb3cdc9101477e4163c67e7cc3b8fd3b4bd6"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91228b019a0379c0064dd3a4996614ad3a2374fd0d92a37f04374936166ff4ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76aff7ed4b8952cdad67cbc838025c137f7e7798f8e440ff01a88bac070805b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76aff7ed4b8952cdad67cbc838025c137f7e7798f8e440ff01a88bac070805b0"
    sha256 cellar: :any_skip_relocation, ventura:        "3ba201ff032c181e8f217138ce4727e92f7a3484a817462cde78a5a7e2e0cf00"
    sha256 cellar: :any_skip_relocation, monterey:       "030fd47b302cdaef0b04967dd2adcd1600d6a24864a7737947a0d5dad2c50a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "030fd47b302cdaef0b04967dd2adcd1600d6a24864a7737947a0d5dad2c50a7b"
    sha256 cellar: :any_skip_relocation, catalina:       "030fd47b302cdaef0b04967dd2adcd1600d6a24864a7737947a0d5dad2c50a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "888fdae2ce2c9344d17ee25bf6412a892b23a542f9584c12084c9ca15c633c41"
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
