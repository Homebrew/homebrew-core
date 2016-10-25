class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.10.1.tar.gz"
  sha256 "3a6fbc164a48cd7d324e108caeba9bdba8c76823092f664a6a68e4e65ec68720"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1263af4844aaa27bb6c6f4c40f07eac80d56200bf4f37734e73e7c0f3c0ff599" => :sierra
    sha256 "01381d4507ddf33833dec6fc26a9aebb43b6a0b4a5668ba88d19a5069a11c55f" => :el_capitan
    sha256 "bcda40f69b492350f97382d9831813aa3d194a42ec5f8d73774fe8a5cb6d4acc" => :yosemite
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
