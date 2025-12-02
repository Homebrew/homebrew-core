class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "91518d1dab2360af844009426fab8542a79c50b80995ac447295a4e709a03fe6"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4583e25e780961c1512fbcdd2c16718b3f8dad386c957102d7ca18d6bad00b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4583e25e780961c1512fbcdd2c16718b3f8dad386c957102d7ca18d6bad00b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4583e25e780961c1512fbcdd2c16718b3f8dad386c957102d7ca18d6bad00b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f115ab6e939ff0823429204b0e34627749574ba8ccfacef72690009443f63d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f11b3a924e3a97d23cb7b5a60602d66a69ccec801069184eaf78f7df9f8e67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "279482de97d750d3b955ce6a8a452dda2e61a2e5cfc80c188addceecedf96299"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
