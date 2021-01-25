class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.11.0.tar.gz"
  sha256 "73cf434ec93e2e20aa3d593dc5eacb221a71d5ae0943ca59bdffedeaf238a9c6"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3f793b85cc360a4c233feee013aa2ca1a6e4a377fbfa2c6f19295dba84c77e3" => :big_sur
    sha256 "d51856c70e962afded7ba89767171a1243f062d958648f376e73bcffc674801f" => :arm64_big_sur
    sha256 "0cc7ded94181a29d12bcd929ddb2ebcd2b87c1a5146447e576bd5937b71406f3" => :catalina
    sha256 "e5ed5cfaadac4ddb44cd6b84d5ba9adb16f793226dec2d6a7cca95caf5995d58" => :mojave
    sha256 "3101131416c93161a0a51ceb0645e6fb5e0810261889200ea951668fd878388c" => :high_sierra
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
