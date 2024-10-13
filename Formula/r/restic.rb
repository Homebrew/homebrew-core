class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "cba3a5759690d11dae4b5620c44f56be17a5688e32c9856776db8a9a93d6d59a"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e051743592db32fb515d36b15cc86ad4ee8d4e44883cdbd9132f4505b08ecc16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e051743592db32fb515d36b15cc86ad4ee8d4e44883cdbd9132f4505b08ecc16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e051743592db32fb515d36b15cc86ad4ee8d4e44883cdbd9132f4505b08ecc16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e051743592db32fb515d36b15cc86ad4ee8d4e44883cdbd9132f4505b08ecc16"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6ffe8afb7893a4314617d105aa42c655dcd0d9111a690e706fff2d07cd8718f"
    sha256 cellar: :any_skip_relocation, ventura:        "c6ffe8afb7893a4314617d105aa42c655dcd0d9111a690e706fff2d07cd8718f"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ffe8afb7893a4314617d105aa42c655dcd0d9111a690e706fff2d07cd8718f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4db1d954f06b3cfff815a5c60849f3c565f4e2f92d9a13a42e2a5a7e4c4c253b"
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
