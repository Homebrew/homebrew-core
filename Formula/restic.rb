class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.13.1.tar.gz"
  sha256 "8430f80dc17b98fd78aca6f7d635bf12a486687677e15989a891ff4f6d8490a9"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d302f557aadf90ab0715d4ba38b73562e640609ab7993e60749f9aca006ef99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d302f557aadf90ab0715d4ba38b73562e640609ab7993e60749f9aca006ef99"
    sha256 cellar: :any_skip_relocation, monterey:       "b20f4e3f5683a908b592cb38a212410e74d77b8898adfaa4609106af734f4234"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20f4e3f5683a908b592cb38a212410e74d77b8898adfaa4609106af734f4234"
    sha256 cellar: :any_skip_relocation, catalina:       "b20f4e3f5683a908b592cb38a212410e74d77b8898adfaa4609106af734f4234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73e11921db005141f386b90ae1966568afec23d763ec8404059d7a088d7a6cc"
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
