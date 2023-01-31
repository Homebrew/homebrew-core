class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.15.1.tar.gz"
  sha256 "fce382fdcdac0158a35daa640766d5e8a6e7b342ae2b0b84f2aacdff13990c52"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "767d2b6fade6fbad2170275c46b01768a071b3c7aa926978d4906c37fcb8a59f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767d2b6fade6fbad2170275c46b01768a071b3c7aa926978d4906c37fcb8a59f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767d2b6fade6fbad2170275c46b01768a071b3c7aa926978d4906c37fcb8a59f"
    sha256 cellar: :any_skip_relocation, ventura:        "7672fc2833ec1a9e0ba6c8358a63b17997dab2f69f21800cd38b9f5b3548e615"
    sha256 cellar: :any_skip_relocation, monterey:       "7672fc2833ec1a9e0ba6c8358a63b17997dab2f69f21800cd38b9f5b3548e615"
    sha256 cellar: :any_skip_relocation, big_sur:        "7672fc2833ec1a9e0ba6c8358a63b17997dab2f69f21800cd38b9f5b3548e615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea5e20625a83bb7180031bdbbe8f8c21a61068786f5c39bdf0fa869614c251b"
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
