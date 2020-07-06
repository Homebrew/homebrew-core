class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.6.tar.gz"
  sha256 "1cc8655fa99f06e787871a9f8b5ceec283c856fa341a5b38824a0ca89420b0fe"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfbf35af0c86f5893fbecfb60085c49edd22ed8eb0861e6921cd85922680de44" => :catalina
    sha256 "92b98a560b99f2a295e8e40689cd2fa9b8f04df62d6846fed8d13b63e0c2f960" => :mojave
    sha256 "736201b7e7014d36f9ccd79a1deee1f577b231975628a2c405ca424882f00e7f" => :high_sierra
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
