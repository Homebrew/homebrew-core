class ScwAT1 < Formula
  desc "Manage BareMetal Servers from command-line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.20.tar.gz"
  sha256 "4c50725be7bebdab17b8ef77acd230525e773631fef4051979f8ff91c86bebf8"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "52c01ff6fe52aebc9d92652b82e197726f7887eb3dcb83eecaba69d96ec27ae4" => :catalina
    sha256 "e818b6b3cf23a0d128edc20717cf10b46e0307e7f7641228589bdee20ef39056" => :mojave
    sha256 "9682d9e4c0fe67549909bc33191f16ef7f7e312acd9316d32819d26eac5dfc06" => :high_sierra
  end

  keg_only :versioned_formula
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
    output = shell_output(bin/"scw images 2>&1", 1)
    assert_match "You need to login first: 'scw login'", output
  end
end
