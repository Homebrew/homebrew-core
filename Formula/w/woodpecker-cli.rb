class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "a6fa0a53f10b5a404124ee89ed1f8723744763858aee62060458a502bedaf313"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4546057eb9f50c5ad221c7090d988854e7fc39d1308f123b22f17f48da0b83e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4546057eb9f50c5ad221c7090d988854e7fc39d1308f123b22f17f48da0b83e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4546057eb9f50c5ad221c7090d988854e7fc39d1308f123b22f17f48da0b83e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab44f0ee90524ca08787418881e993157efa527b9a50e395dfe38ff06ad4f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e821e66d34899ed80e3d00008c3969bba647afb23e43b74709000277cd10f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed603dcff573bdd7763edc323458af067effc8a5f6619bd5bc1e20dbd3ab06f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
