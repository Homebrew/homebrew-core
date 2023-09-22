class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.4.tar.gz"
  sha256 "6a1a756e0ee13bbe315d3f6c131b3d7bdc5a25fc61689ae63f9ac48ed7d3f6cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4528d6d3d79a9f4a97a64a8913fea113f6c0c3bdf7a887c56c4e5af7fa385329"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea087d179262a94fd714037ac272763b363a6470342d4211b8a24a28c70b6c3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21e103e09eae3cca4ffdec7d316d616a4606de526cf1624d7d1418998aadad00"
    sha256 cellar: :any_skip_relocation, ventura:        "9f55471189f2687db50e19c9bd016030abcbc27e881ad31ad01b8f77cdeca80a"
    sha256 cellar: :any_skip_relocation, monterey:       "568aee7ed05a3d3d064f12ad592e7f48a044152919b83f7e25afceaa94940f1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a4bd26ea4610a124270af57e5398579711808f5b65108a6b7793862294dbbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9bf8ac68b131a9c6bb69fe50ad75e45107ed19ed76a21d8e0992ac3fced1469"
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
