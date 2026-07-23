class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "bb9b1a19040744d26d8a79be029d4e6b189c45ccc9d8831d7fe367d3c33df725"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46e8a729f34715368444f8b7d4b6e99dca7ec575f7c677bba40bec71764c1dea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e8a729f34715368444f8b7d4b6e99dca7ec575f7c677bba40bec71764c1dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46e8a729f34715368444f8b7d4b6e99dca7ec575f7c677bba40bec71764c1dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "03df89b7f2a18bafe9021cfd24f32cf7920cac3f118bb8cc8fe042670370e93f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13fa3948a9e6b498bb2e38178eef94685b0cc60760ac3875941e72595ec20a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3fda69d9bba81b3d9fa3e9854377bd2b02c23681ba1d2eb4a8925dc3cb936d3"
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
