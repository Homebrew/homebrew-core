class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.5.4.tar.gz"
  sha256 "de8595d9985fe534b49084efa3ff875de3af16bfb70e3b4685b345bf5fa3bed2"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a255f26b4e9f0c1d9eec2b78ac6d43a3f3cda6e39d3fe707432cccc8a6b5181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1f2c9924cccee65f8245231a0306fbcb1d6eadebb919ae4ba2ba6167bc2b62a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42efa2975701f5a7ebce3e35151d92e7d1dc3803d69edafc08af2fa417b05958"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa103dc6f11b63ca4f93e70a806807b11db5db3410c6e4950c79ea4890ecd775"
    sha256 cellar: :any_skip_relocation, ventura:       "93dc167ccd45b8061d8d46b9c5a6894d91f679df9a5a85e70c839e63ca628c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c189c2a3c125974696b1143d3dd687cbe6ad60c9ea8ac2681498323a35fee8b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end
