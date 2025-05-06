class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "fc068d7fdd80dd6a968b57128d736b8c6147aa23bcba584c925eb73832f6523e"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5e5f38a7c321b978414f6539399447307087b8f62ec240196cd8e7f486fb89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5e5f38a7c321b978414f6539399447307087b8f62ec240196cd8e7f486fb89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c5e5f38a7c321b978414f6539399447307087b8f62ec240196cd8e7f486fb89"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a80b0c01d0b542100e14c75ebcc7ea6d9690c9c113c3a043ea17559d20149e"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a80b0c01d0b542100e14c75ebcc7ea6d9690c9c113c3a043ea17559d20149e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79c6bb25ad8711d2280bc48f9bccb44fc854a03335b664b696ad919c3a60cb53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a15fea59111ab70cdbac9fa18b5528901a2dbdf4271f08d6438f9c0f6edc80"
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

    system bin/"restic", "init"
    system bin/"restic", "backup", "testfile"

    system bin/"restic", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end
