class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "cc5caa50168e2dd94600e7cbb7449d1435fa6a656a641be98da483b3de871958"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb667b796bf993370f6b80bfebbae08d066690c01146058916f95d97f584e40c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2915a7cc09f41ca33ca13795a8822494b9323137583486cf8f3af70c8398cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c302a8cda670f6b3dba3c5b0640165895da997dc83a3d9457cef9c5f5df83585"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd3bf88a15aa01f5d5d710deed2950bdcfe46ef88c2c17298727399a8daad4bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4dc6ed485efcd40a9c20ea058c29bcc97a36e5afdf2b9219032216a2288e363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2056e0b7edc603c871ce11b932c8386f3e01ef86536e88c03371db27b2be69b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
