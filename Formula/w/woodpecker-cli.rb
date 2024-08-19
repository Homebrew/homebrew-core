class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "4ea8563221807153302ebfc3d1f9c826cafadcaaffb2ee0fc3e2f67cf06988af"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62118fa8c27bc74a51b0b0dade07b6c5ff32a5b2e44ed77ecf950e57dc954aca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a54616f6b529a1fd6b9b0714e0bbc91e140a1ab972f27645653baf508872628c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a500dd4a280d84ae81a982ddb939354380d175157f7c5330a11884f0364eb9be"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a80c6d0c0890b3fd353cf81500ee528b5f8733aac652bb46823166c5b4305cf"
    sha256 cellar: :any_skip_relocation, ventura:        "2b335c000d7f30904be9194261eecbd411ff86521e7baaa16b8e77beaea99f76"
    sha256 cellar: :any_skip_relocation, monterey:       "a5029bff2021870610f4d0890b91741b2736a84646ef95924b6be9faabbf0abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc089a3f76f42de6dbcaa6e417976c09b560f48abe97dd960524f7056791ba4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
