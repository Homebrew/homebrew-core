class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "0d0d86a2cb776a9c0389d683b82274aee68d9ec308468035b071cafae500c9ce"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8916f1b08a5c3b40e049c88c3b5a57bac8d217a204b86f9437951a77053a2be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b0dc1504bf0b553e57ba9d2592cabeea908ba1f92260179e85ad110834c99c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b321f4402f4a8ee6c378140cd8f35cd9599a25e49091c61cab041d838893a69a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a8349e92fe1dcc88fcdc931a6739b6781c6994ffaf84a981f893c9ee94ebd4d"
    sha256 cellar: :any_skip_relocation, ventura:        "ada36bf0f39acd9f675cd6308dda4d373ac8b75570681940fad39652a1b33d7e"
    sha256 cellar: :any_skip_relocation, monterey:       "4eba21254de390359a9dc6895efcafe9df3b5c3d8474040eb907a0a4ed8b16ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f786e1fc6f2c8395bbf3945c8935f98144a44cbb8b87180cd25c05c5379b088"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not setup", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
