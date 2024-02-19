class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.3.tar.gz"
  sha256 "a729a8f12bf7758fd268c11867c60da00e36f4339aaacbc3e4ceb8e3a4eba33d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b25a19baee047513d89cd1b938265bec85687fd40011213226c2d0ebc6ab445c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05beb7476b21b159300bff707a115330a06260eac67be911d33e06f0fd139adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db01ac138f74ca3f231750ae04b5295884afa3cca47adc0227bcf9b4d51d410a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fe59d9fb380a359daf0ba7e4e4afe36d1cffa11a8966aec413adafb302cc805"
    sha256 cellar: :any_skip_relocation, ventura:        "3688984a2a82796d277fc864461949d4acc4d3044eb7f15d286d3e4e788f0490"
    sha256 cellar: :any_skip_relocation, monterey:       "ce1d21947209000bc62568703b458d8fa0be1f3f08b1c8685b910d29f3a35730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed5297397a1e37a449d79406fccc96b71d6d4250a4a53d15baae7170d92bb1c"
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
