class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "d736a57972bb7ee3398cf6b45f30e5455d51266f5305987534b45a4ef505f965"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa155e4d25c221e5192876f1d4cfaba53f7a9e2a2e0a3c9cfd1534e4c4784d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa155e4d25c221e5192876f1d4cfaba53f7a9e2a2e0a3c9cfd1534e4c4784d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa155e4d25c221e5192876f1d4cfaba53f7a9e2a2e0a3c9cfd1534e4c4784d5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5847f5dc01de6dac2be7ebcabf85d9a86b793855c018a7e4a54617eb44ff2037"
    sha256 cellar: :any_skip_relocation, ventura:        "5847f5dc01de6dac2be7ebcabf85d9a86b793855c018a7e4a54617eb44ff2037"
    sha256 cellar: :any_skip_relocation, monterey:       "5847f5dc01de6dac2be7ebcabf85d9a86b793855c018a7e4a54617eb44ff2037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222a45805a06ee54cf489bfd56108be24ae66349c28c6a36cc57d842ad87a614"
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
