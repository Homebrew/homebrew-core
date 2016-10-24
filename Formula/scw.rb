class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.10.tar.gz"
  sha256 "2c8193e411dac83f31b4c2f899cc7b4793380d91c6196c831c4bfd41c47a58ad"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc479e8c440c9bf5ebe83032f2eff5bddcad390ad31aa64f876aef2f6c88bc71" => :sierra
    sha256 "dba9eda78980c8a5812360ae2826ead7a6ae0d1573239720a54437044d38f313" => :el_capitan
    sha256 "4f987ff3b1cdbfb20d5f8585aa4588e96725437c931a1568c158441064f1f566" => :yosemite
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
