class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.5.tar.gz"
  sha256 "e22208e946ede07f56ef60c1c89de817b453967663ce4867628dff77761bd429"
  revision 1
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea2d49bab5d855579964096fff8a061ce14295199f589d6d474c97ea9d504bfa" => :catalina
    sha256 "68b427514497fc3e5e886af43fe04c477a54d1c08c6f7cd9244ab09b170bd47d" => :mojave
    sha256 "1b0a856fe819e6923abf28590bca2980fb7fb23af46230224d171579b85df7e6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    ENV["CGO_ENABLED"] = "1"

    system "go", "run", "-mod=vendor", "build.go", "--enable-cgo"

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
