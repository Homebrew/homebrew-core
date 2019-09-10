class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.20.tar.gz"
  sha256 "4c50725be7bebdab17b8ef77acd230525e773631fef4051979f8ff91c86bebf8"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57a21449714df68f713fba876e8c2b4a62de751fd48cd51c15b5109d4a6fb74f" => :mojave
    sha256 "f292e2359a0f203d78598f08c36c333a7e418bdd2da019dcb12b4a662b1d2e36" => :high_sierra
    sha256 "585ec2a43d879705288fc165ca77f19d027976da976e38e72874b1273128c790" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/scaleway/scaleway-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/scw", "-v", "-ldflags",
           "-X github.com/scaleway/scaleway-cli/pkg/scwversion.GITCOMMIT=homebrew",
           "github.com/scaleway/scaleway-cli/cmd/scw/"

    bash_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/bash/scw.bash"
    zsh_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
