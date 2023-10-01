class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https://github.com/sa7mon/S3Scanner"
  url "https://github.com/sa7mon/S3Scanner/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "55d24351a580cd6668e8bb982cba4a389345551e2e7c73e4fb5c17e577935024"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b99de49346f8719e05913b344c24b229a10d45f45556eed82408385ace365978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aca838462a1cea0dbfd8039971347e71ad4e5a77259901505fc1e13030e7f9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d60dd8c26b8c816fd79698dcdda8eaf0a743dd6cd7c6e48cf24ef99b48ff268"
    sha256 cellar: :any_skip_relocation, ventura:        "392be975b54615a477ef7df2d226c48451722fd85819f1d769c078b598548a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "07ee2a5eb5177dcfe922af24e4be171d0ce0b4c2fdca131c5dc5c0eb90704b65"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee84fd13b234eb5f4b7e160c30385ecddfefe994dcff9b56aa14cb22857b087a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f255c28dbf9fc38442b696e56fcc7919d19cb2e6841a95264dcbbd4ba2d02e6c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
