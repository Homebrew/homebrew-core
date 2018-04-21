class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.16.tar.gz"
  sha256 "bda49f5b33a3214aabbb69a51284fc6ca73110cacecbd8ff3edc0749a44cbced"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f490ae99ca9b4b8d31e9a66d9e294067975248676f0a3efdcae4a89a954ce83" => :high_sierra
    sha256 "830cb132cdabe18304e76affd1a886070c5a32a83774fa5f02d935efa5699f54" => :sierra
    sha256 "d6f00db542d76b7db785e25a4b3fe6d2d6810fee9dea44f186d7c610fdb39ef6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/scaleway/scaleway-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/scw", "-v", "-ldflags", "-X  github.com/scaleway/scaleway-cli/pkg/scwversion.GITCOMMIT=homebrew", "github.com/scaleway/scaleway-cli/cmd/scw/"

    bash_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/bash/scw.bash"
    zsh_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
