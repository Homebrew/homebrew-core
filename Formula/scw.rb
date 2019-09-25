class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.20.tar.gz"
  sha256 "4c50725be7bebdab17b8ef77acd230525e773631fef4051979f8ff91c86bebf8"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c7a69355bafd8c035bb2878f6c9c7a9a013dacc8cdbdc1997b66bc49f7fd7f0" => :mojave
    sha256 "87a2f754ab3e1c5434a2b24b855de6e5da39990bf9cf558416fc2e259d66d0ab" => :high_sierra
    sha256 "b5727720c3f4173012c81b8dfee1a942262d430ae6951c0f39a9c28aefc21b83" => :sierra
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
