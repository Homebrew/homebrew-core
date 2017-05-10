class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.13.tar.gz"
  sha256 "0be6076af3d41f94f27138415da394fb5424a654214edab58b9bdb1c9fd8a2cb"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80a12f0378bf0cc4d6821b9dd9c3381b89771e95f523d57d876b7d7e316affa1" => :sierra
    sha256 "792be6c0a7b700ad9ae6c618dde4e6e9fbf7a35e1c204ebf4d366c805d191cec" => :el_capitan
    sha256 "d5d5189fd3a4e2fcf368717e770a811f5a7c4558022b450fa330503b106d1c7e" => :yosemite
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
