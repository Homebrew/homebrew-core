class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.12.0.tar.gz"
  sha256 "39b615a36a5082209a049cce188f0654c6435f0bc4178b7663672334594f10fe"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f1be439ee37bc32802e705b595541c849f08034cd74836c03e5a8cc9c674b6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "62e870aa5d92ff24c3508c83a3a3097137127c6bcd567968cfd99a44d14ab068"
    sha256 cellar: :any_skip_relocation, catalina:      "408932d412c7abf1592f07bebb6ec32eb6af2b0b9efc942dfd661027c839e6dd"
    sha256 cellar: :any_skip_relocation, mojave:        "1e3fe2725e40ce54501167afa71979873a1d651beb0031a0c84dc923606ecb30"
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
