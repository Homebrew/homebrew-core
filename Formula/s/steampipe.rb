class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "abe43a3dd5400fbb23373314cad1bda2f6da0ae5132f261e5260f4dee4eb8970"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3df71626e45a9be247a46fcb6ae0eda085df20184f09889b5ce0c250969e3c05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e7f0406a063959185f8d823402f980ed9e962f39823832c4c588bb7adf410e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5e58e6265202531f381e2c23ce830374a1b628a669fa9fe09ea590e1721125"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2868353995fd291efcd8a25ab5f05ed25d4fa13c57d830d3a6ab2b803a9654a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf98250de7905bec91e2bc79f88a78232c2f961637b5a11d8dade102f78f2784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a8c39b13210dc906897a430f97ffec8310e40c1b277582813deb545718bade"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end
