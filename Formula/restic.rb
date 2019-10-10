class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.5.tar.gz"
  sha256 "e22208e946ede07f56ef60c1c89de817b453967663ce4867628dff77761bd429"
  revision 1
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f9218c65c562b2eace35015cff1a2dafd5a59dc5973165f3b59d7165f7d0a6c" => :mojave
    sha256 "1775322bbdcd094cd3cded9097b5e07588fdd4c40e447fd2db319e37e8f2704e" => :high_sierra
    sha256 "450abee766d22cd546b03beac010cef7e9b268aa0f9a223519697e3660985805" => :sierra
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
