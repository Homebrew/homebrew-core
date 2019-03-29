class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.19.tar.gz"
  sha256 "307bb2a67cd8b8a7fb58524dfe3f65bbba476496c051e289e76f11d0508a0ab7"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab6884f3d8014367040f6e8846ffc0c76783ff164beff1966740f55e3f2f7683" => :mojave
    sha256 "b3af7992cbdfe233dd3f897001ea5ca8053ee540b282c1e2de4110e70a5226f3" => :high_sierra
    sha256 "4f2ddf1b9a4dd05bf431618af1849345ad2b2f476a4be0f9e9b5804019a7e114" => :sierra
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
