class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.13.tar.gz"
  sha256 "0be6076af3d41f94f27138415da394fb5424a654214edab58b9bdb1c9fd8a2cb"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fa18d6dabc15431d158298e6a6ac27bfe3bd9bc99de97b9b685518ccf92ab00" => :sierra
    sha256 "3fc45c7cd3909bcc34541ce9dd5306bdc057a2f7fdd6cb96d47f91752d095343" => :el_capitan
    sha256 "9cde79706ea4556994a01f8e726615319ea309ee6be197228169a9201254f74b" => :yosemite
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
