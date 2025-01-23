class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "966161efc0f65c6f836503dfba9a3e2240ad6e54c76d83817fc99532808cf049"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ced1820bc7116f287cf41eb8a76089470b5eec6f7b7ac4f8a857c824cf8b760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ced1820bc7116f287cf41eb8a76089470b5eec6f7b7ac4f8a857c824cf8b760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ced1820bc7116f287cf41eb8a76089470b5eec6f7b7ac4f8a857c824cf8b760"
    sha256 cellar: :any_skip_relocation, sonoma:        "77017761b8fcd63d811d483f5055adb292357a5ae83d1016620a700753f37935"
    sha256 cellar: :any_skip_relocation, ventura:       "77017761b8fcd63d811d483f5055adb292357a5ae83d1016620a700753f37935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061c93a10edaeb1e1237db4559091ea7cf3bc84b844aee2b27d23326b438fab8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
