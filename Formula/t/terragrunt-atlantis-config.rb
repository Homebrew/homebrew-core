class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "eefc48f2bedc11c154c6c7e088bb10316d811b2d6b851b11d37d80f18a28e517"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261f959f81e57e9d04a6b54f405b74c9d26543b266badb1b6dd2af33fec1d84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "261f959f81e57e9d04a6b54f405b74c9d26543b266badb1b6dd2af33fec1d84b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "261f959f81e57e9d04a6b54f405b74c9d26543b266badb1b6dd2af33fec1d84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "109f864174bb9720779d3b902bdde2779596b889caefea37ae2405083797a6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "035faf5b65044abb053f4739afec6947c0934af43b23e94760da3172caad408c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0ab073df774ef3d5cde7524112fd229edbd38ee219d630c533da49f39d6f2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"terragrunt-atlantis-config", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}/terragrunt-atlantis-config version")
  end
end
