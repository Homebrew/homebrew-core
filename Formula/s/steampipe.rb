class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "749d5ee59a8e07aae85c59fc45fd51f8549c49e2608221a3dba1ce576647bdb7"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46dbc5693869dffb78663f3472c023f67875b1f49c19b4c0f8b8262ee6f5d81a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ff17c9a4d0c3ea7fff24c51027f2c3ccc0fe927910b759e357946d795ac403"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47809d4685494a7b7ea71190fd97c4c9a6e98277394b9ac84d9a8d7feb96824e"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbd049f031682fba4dd1d6abc82ea4d08ace4f7e370d86f6316be8b78565f4a7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8cafb610d00accbf44fd75f426b5d058706f9d6464439eff003499eb0548572"
    sha256 cellar: :any_skip_relocation, monterey:       "7cc1d62c2ee5d438feef363dfaa2b3275048ac0d11cc30c316e371fe7d1e234f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5592f058ec8d30a64bee9c70e56e07124826d24b0c01fc7c1ccf25d5f323c4cb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
