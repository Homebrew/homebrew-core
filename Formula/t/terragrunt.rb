class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.9.tar.gz"
  sha256 "79043c3bbed2bee61b6c71f77fc7998d09d45565c08fa1e6013c417b675ffcf0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb754b83122bb78e163981e3fb835818c0a46ea6cc127609beda4aafeac71f38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aaa08e33060ede6a94795642d9b21a2aacfb6d6b7dfa3ef39cb5e59b3265d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47e98ebb9b7e1f953ba00a27c50f32ee09d8ab0926cbc14dbd5c114d0fc3ab5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "89f35fa7e5d570e23fd2d2911cdff1ce1ef508069549ae0f5c6c771982436285"
    sha256 cellar: :any_skip_relocation, ventura:        "60997d0446a48951aeffe847b27f092edbf0e121ba9c820013ab138758e2b793"
    sha256 cellar: :any_skip_relocation, monterey:       "780bcf1a7ae662a2655fc6fb7c5f023701b2e434449d31f5dd4173b8afca2229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82d9e53842db799cfddd52454e250fbdf1088e22e8408ceb56b5ffd8adcb949"
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
