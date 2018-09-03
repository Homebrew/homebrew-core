class Scw < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.17.tar.gz"
  sha256 "8e9bdd72cbc5a9e6f89e61017c8f6f8b070b5dab23d926d9234ef5cd9e014eda"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa6c21ccf356953d905c5488cb45db36c5fee6b98d7e8123fb5aa7aaac311269" => :mojave
    sha256 "de6c55818edca4e83724e54cf674f31683f32467abbeff92b35809be38e04a19" => :high_sierra
    sha256 "9e9652cb4c37db3d9dcb6c9ded77d2cc268c521640446baf9d473ad82a620085" => :sierra
    sha256 "477f07db8b60db095eab5110d4fbd441e54ed567a540f100d293a6a384fadf94" => :el_capitan
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
