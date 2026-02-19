class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "d26842a3ef75feef22270db4250d16d106e7f9d3ac5f4300ede1b6fc795cdaeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80151377a0e570445e58a123fc9256fefdd756fe7bf8ab102de37ca67df34437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24658c7b39059111b71cfb881708de816018d13145e3c4e4603267c072e944fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d967d219f6d7a044a13dd6e2efaa495947d68e0344699d013c6ad3942f7e1d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3689cdfc20e5b62ed6853f8d71ef4695ba9a9e0884f5965ce5b5f4aafb5a24d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "504c4e3d827048d30f47dcab2d2717d13ba99e9a8d90e1775b99bfd5f85881d4"
    sha256 cellar: :any_skip_relocation, ventura:       "3ee6c78f1c51e03f2d26121218c815959e2e7287b0825dbd56f92b7ffd0b0403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87ad9b0ee49109813a35ee1d7030457a1bf8a72cf75938562722389dfa1d26ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386c785c6a49becb1da6ae31414ceb1d95b9ad8299d9ebb34afe0c10a6d98dbd"
  end

  depends_on "go" => :build

  def install
    # Turn off homebrew specific database checks
    # Issue ref: https://github.com/xeol-io/xeol/issues/568
    inreplace "xeol/db/curator.go", "isBrewTest == \"1\"", "isBrewTest == \"999\""

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol db update 2>&1")
    assert_match "EOL database updated to latest version!", output

    output = shell_output("#{bin}/xeol db status 2>&1")
    assert_match "Status:    valid", output

    output = shell_output("#{bin}/xeol alpine:latest 2>&1")
    assert_match "no EOL software has been found", output
  end
end
