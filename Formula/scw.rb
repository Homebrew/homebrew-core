class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.10.1.tar.gz"
  sha256 "3a6fbc164a48cd7d324e108caeba9bdba8c76823092f664a6a68e4e65ec68720"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d09bf464eb8129e19041ad12b5e0bf18ccdf2ed0847652193b9bcfe00090ef55" => :sierra
    sha256 "846ddf5f0960b384fcd5701e64c0d91e8cd65faa0d873f4fc7a3cc773d310bef" => :el_capitan
    sha256 "b6de5c501f9c086446cf9fa1cc211d97b925fede54e87194ec94f4b7ea27a112" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/scaleway/scaleway-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/scw", "-v", "-ldflags", "-X  github.com/scaleway/scaleway-cli/pkg/scwversion.GITCOMMIT=homebrew", "github.com/scaleway/scaleway-cli/cmd/scw/"

    bash_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/bash/scw"
    zsh_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
