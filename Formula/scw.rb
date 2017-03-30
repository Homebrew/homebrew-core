class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.12.tar.gz"
  sha256 "7a23ef6960fe280dd19f8e2e9b0fff6ffaf4b8446ddc7833b530901875652e2e"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a07e866cf68e5223ed037f78ddd90ff18f5d2c98abdb4cb177d67743b74b6d6" => :sierra
    sha256 "648e0aa0439bf4f3b5d681ccad17566515fb7ab47cb64cf6087396e8995a0428" => :el_capitan
    sha256 "4ee52b684b35d5831e9ff648dce4da21a94564ca1d877133a71a9f01c36a0217" => :yosemite
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
