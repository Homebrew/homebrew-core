class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.13.0.tar.gz"
  sha256 "b3c09137b462548f44d764f98909534bef6e85fe029d4daf60545642cdefd3dd"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ac1446d73779b4cc8b8e8de2c40f0f51b276c0ee31633a2d3c096a642be6683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac1446d73779b4cc8b8e8de2c40f0f51b276c0ee31633a2d3c096a642be6683"
    sha256 cellar: :any_skip_relocation, monterey:       "57303932bc30111dc466f855485976843a861bd363ca2aed9a4be61917688b9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "57303932bc30111dc466f855485976843a861bd363ca2aed9a4be61917688b9e"
    sha256 cellar: :any_skip_relocation, catalina:       "57303932bc30111dc466f855485976843a861bd363ca2aed9a4be61917688b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbff108d66e16eefc8ccefe8001a1c148057148ebe8ca67cbc5ec43a4a5de75e"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build.go"

    mkdir "completions"
    system "./restic", "generate", "--bash-completion", "completions/restic"
    system "./restic", "generate", "--zsh-completion", "completions/_restic"

    mkdir "man"
    system "./restic", "generate", "--man", "man"

    bin.install "restic"
    bash_completion.install "completions/restic"
    zsh_completion.install "completions/_restic"
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
