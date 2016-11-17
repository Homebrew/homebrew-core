class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.11.1.tar.gz"
  sha256 "119ac181845eb4245e42af760c62f3c9ce2e44f518ac87ea0eb78c0c0c1aca98"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6a07fc46558ecce5d9801aae5bfe3216d11529f594b1adc1ebc6ecd5f7a2983" => :sierra
    sha256 "a556ea18256acbbb9005584b38da488f89a76aa1a138e209fbf215ce88ef4a90" => :el_capitan
    sha256 "2d34b59c7c1a9151406996467d8c6f877fad4e6868cffa4292ce1d6e80744984" => :yosemite
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
