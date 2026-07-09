class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "800779b6c4c2396971c0567b09ccdd435e03155e1a0ec94e8bbf3d98641a8bc2"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b69c21f735a13de6c74d6a097199fc6e98fd794c48e287a035dbff434bfcae41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b69c21f735a13de6c74d6a097199fc6e98fd794c48e287a035dbff434bfcae41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b69c21f735a13de6c74d6a097199fc6e98fd794c48e287a035dbff434bfcae41"
    sha256 cellar: :any_skip_relocation, sonoma:        "88bd2806d4f39f51283c47acc731fdb4f40be48fecc8dc21b4052fec4adfeb06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcbdd753bbc27c3f5a799759e604f4ba766b2d0f9e955f96b240be0c18e4d61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67694c26cba2e014f9cba9fa7e00ae8b8d43610ab7a9fea58cae3a3c57919928"
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

    system bin/"restic", "restore", "latest", "-t", testpath/"restore"
    assert compare_file "testfile", testpath/"restore/testfile"
  end
end
