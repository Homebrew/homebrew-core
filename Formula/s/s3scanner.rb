class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https://github.com/sa7mon/S3Scanner"
  url "https://github.com/sa7mon/S3Scanner/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "ef4702f0e7b2d2575febc1ebc58f9503342e65e8815ed0e7cafe532a134a5c8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aa512469b6b7aff876e164956157ee54c89399c372f1167cd1fbd8593172db5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa05d32e755dcc635183e99eb8e54f818129a7d44a631ffc65a9c63cdafcceeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bca8ab3654f3299393ac55f1a0765dca0a3caf01eba2a524381d5e115401c61"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa79ea9ceaeaef662aef154fcb919f8c3b360d46ea2e3fb47ddf4f632857520"
    sha256 cellar: :any_skip_relocation, monterey:       "23553777b35f95aa7f7b243a4c6e5bcd83042e9c9bfa9f7810e8ac6b85346acd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a555ed6dfff6696a94f668be5d0226dd757e9ec90663e4f9136af82d56f0e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3570835053f9540f07e4010438b16750fbb87ccf0e698a5fd7b848698b00fc7f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=v#{version}"
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
