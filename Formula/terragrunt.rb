class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.40.tar.gz"
  sha256 "37ad2bdc9b72b3380174c5886009626ff2369cb0d9c7e19c45f97e152de131fc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "520dd7b8cda37781ebb360bf1d4e5d2f4d821a6cd5ce7aabca372a838473d69e" => :catalina
    sha256 "8cb7d2ffd5b10620a4450c0690ff8bdabe0e9db4112ec47d5375b6752bd36008" => :mojave
    sha256 "191bd23da2b461c36d1e976ed03b24a1c46495f14451b8f427b3c6364a927914" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
