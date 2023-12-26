class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2b5a1e4a87730d33e7096460f70e321cfa365cea6a3b0a9ddaa4497963de9cce"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7de61040a5a56c51360ef03558e8393af0b61c9be6b9f7aded27da25d679c08f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a36c09d3d29e180067530546ec2886cd90adc04d585aa5cb8cd7aa8c0c4214c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2787be979e65d97c8e4dbc04ad5e403ffb479638943ebd04e94633ad3ff036ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d75dfca05dc0a9b98daf844fd22acc2bbc461678a9b89598c9eea2e0590a584"
    sha256 cellar: :any_skip_relocation, ventura:        "2eaf4651ae1a341f0167e42b62c6d47201604779252431f6f5b1b46d1fe7db1b"
    sha256 cellar: :any_skip_relocation, monterey:       "842d2ea39771222968a939a4940ce8ed97e55c3bbab929216a58e0aa803e16a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62c0fb747fbac7de6a6649cade4c10d58aac97f725b8d32f64c882abecee682"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "Error: you must provide the Woodpecker server address", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
