class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "38e002ffaaf12e9c5b1aee11126ec5edc047a10e0b4e34253f4c506b2dd51c70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "912213ac93a096989989c99cb8e895c9bd7421b53427ef0410ec5344fa296e70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49a1a26436f21beba8001052962943db88f3f45583d1fe89a1118f75309a6df9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "636e3bef9f71306ae4cf21e2594692b278bb05cdb29eed7fe9f263eee9df809a"
    sha256 cellar: :any_skip_relocation, ventura:        "17873c94c2f31fbda002bd074e99785d3b85afa2766b11bd0ad16dce6edcc122"
    sha256 cellar: :any_skip_relocation, monterey:       "0301da7453ae57d741668b0da964deb381d1d3fd08a25792361bbf975e0ad4e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7cb0f2fceb113edfbcbf0c8948ddc73e082b7359d032cc595f5218418dcf81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44319c684ab58ca0df32d5dc22de52c0963c7b14d0b8a8328c3efa1764bc0d8"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
