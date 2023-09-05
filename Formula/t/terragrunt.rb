class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.12.tar.gz"
  sha256 "3e3b65da88bcdbbe59834feccd666c8b3bcd4995e02c0645ca0970cffc545df2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c324338a56de3f1aaaa7dca44a7368f81b340731dd2ed257d576b92c8bcef0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b237ef61e1752f33d28ff06865e3441fbc02c8d38b8c48f3b3b48811a37400b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0ea4e4ed9636b3124a9b214dd6154e36cb19b607a0e6c2f24d99380b2dd5fca"
    sha256 cellar: :any_skip_relocation, ventura:        "c24a5efd01220f8129e25ba3161915406930496e812a4e5def053a310271fc8e"
    sha256 cellar: :any_skip_relocation, monterey:       "31592518a5d8013f34bd7c6ed7af1181a056ee16881d72ec3f3e030786679862"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cf99f3d9ea637d626423a7963bb4266d12adc9748b66259bf7ea0251ab60bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12eeec257dd7b7ef89522e40821019ecc85275fd72440859973b6d458ad1906"
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
