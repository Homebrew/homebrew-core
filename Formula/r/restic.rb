class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.16.0.tar.gz"
  sha256 "b91f5ef6203a5c50a72943c21aaef336e1344f19a3afd35406c00f065db8a8b9"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4cc654a7b8b733ee1d072b25cd2492a04432f5338016c6b8837c2eca02264aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4cc654a7b8b733ee1d072b25cd2492a04432f5338016c6b8837c2eca02264aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4cc654a7b8b733ee1d072b25cd2492a04432f5338016c6b8837c2eca02264aa"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0999b52b7f1415b0081595c1d75d0a0500b108085ba32d7db914a0641d2a78"
    sha256 cellar: :any_skip_relocation, monterey:       "4b0999b52b7f1415b0081595c1d75d0a0500b108085ba32d7db914a0641d2a78"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b0999b52b7f1415b0081595c1d75d0a0500b108085ba32d7db914a0641d2a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697d0d2cb19d47983a6e58e764f9fe46d92a1728cd1d7482a6db950ef01bd5b6"
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
