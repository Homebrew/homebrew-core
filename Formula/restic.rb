class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.13.0.tar.gz"
  sha256 "b3c09137b462548f44d764f98909534bef6e85fe029d4daf60545642cdefd3dd"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac34f5a9df926e51febf7fc69df6ca57c7fd2c5705f9b1fe057a9e36cf8ac952"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c42f5dc067e1f3d2fc001bceb623564bff4b2bc692c486e2bc69911fc4db932e"
    sha256 cellar: :any_skip_relocation, monterey:       "189c9d1377a6a0d3569a6c9ce5f716df4bb75d685623e46201829d018567b2ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "b776b9a367a6a290d7ba970ecb560e1bca188534a868020ed37f5e7d8bcb33a7"
    sha256 cellar: :any_skip_relocation, catalina:       "c8ad9c03fcad3d00e354208d4225f5a625185f2b7179e78f93f759748b80cf8f"
    sha256 cellar: :any_skip_relocation, mojave:         "a3f6155d24196e1f49fda7cad19da3753428ce1cae63e283dc1b66e623a0c756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce82bf169c87af5f42b0b564179148d06ed6b19ae1bde13b10e04a8ccce5e3a"
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
