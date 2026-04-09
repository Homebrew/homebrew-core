class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https://github.com/sa7mon/S3Scanner"
  url "https://github.com/sa7mon/S3Scanner/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "2d333c31909baa21e024d11db1b03647fff3d210d73fa7fa47f598d3d459a20c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0510af529926557aa5c049cf576240df2a44f0d48b2d978cbd4dbe8bd3ed84f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e8d161cfdd4356026c4625343354a2c58c59cc07542cb5b29b7117acffd19b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e8d161cfdd4356026c4625343354a2c58c59cc07542cb5b29b7117acffd19b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e8d161cfdd4356026c4625343354a2c58c59cc07542cb5b29b7117acffd19b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa0fdf4a17911994cb55fb32bb65a3f1eff54436f860fc87e4acd6207c06e048"
    sha256 cellar: :any_skip_relocation, ventura:       "aa0fdf4a17911994cb55fb32bb65a3f1eff54436f860fc87e4acd6207c06e048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae7c856c4e60dd64627acb45500048bb41fe1f4f49bc3a563969f794af7f062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e76a8131cd2e58061e5bcfdfd351034b0222016877e349f58431b8b2d3400fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}/s3scanner --version")
    assert_match version.to_s, version_output

    # test that scanning our private bucket returns:
    #  - bucket exists
    #  - bucket does not allow anonymous user access
    private_output = shell_output("#{bin}/s3scanner -bucket s3scanner-private")
    assert_includes private_output, "exists"
    assert_includes private_output, "AuthUsers: [] | AllUsers: []"
  end
end
