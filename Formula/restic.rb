class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.13.1.tar.gz"
  sha256 "8430f80dc17b98fd78aca6f7d635bf12a486687677e15989a891ff4f6d8490a9"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525e62a21ce0ffe1d91eb2f99be699a5bef4cccacdbb67fd328a11506ca78ba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "525e62a21ce0ffe1d91eb2f99be699a5bef4cccacdbb67fd328a11506ca78ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "fe187c82575e9c7877976974dd13a47b9d43b9ddffd16e07ab0dbbad8d95509a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe187c82575e9c7877976974dd13a47b9d43b9ddffd16e07ab0dbbad8d95509a"
    sha256 cellar: :any_skip_relocation, catalina:       "fe187c82575e9c7877976974dd13a47b9d43b9ddffd16e07ab0dbbad8d95509a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9beed0be209369479f0ad798ed215becd5c271479e8d3a6a6cb49fa8400067b8"
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
