class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.net/"
  url "https://github.com/restic/restic/archive/v0.15.2.tar.gz"
  sha256 "52aca841486eaf4fe6422b059aa05bbf20db94b957de1d3fca019ed2af8192b7"
  license "BSD-2-Clause"
  head "https://github.com/restic/restic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35509228c7cd14a3898d7a485cf84e7269792a723b026c720a76f782b3f03929"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35509228c7cd14a3898d7a485cf84e7269792a723b026c720a76f782b3f03929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35509228c7cd14a3898d7a485cf84e7269792a723b026c720a76f782b3f03929"
    sha256 cellar: :any_skip_relocation, ventura:        "3e3c6a1ab96adf0637e68f4b9b6e17f6cf9843db9c3175ab04b895c162828d91"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3c6a1ab96adf0637e68f4b9b6e17f6cf9843db9c3175ab04b895c162828d91"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e3c6a1ab96adf0637e68f4b9b6e17f6cf9843db9c3175ab04b895c162828d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d6f87ae481311df78999f60b580cc41891686b40d31a066853fce116b67f1a6"
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
