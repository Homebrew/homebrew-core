class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://github.com/owenthereal/upterm"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "263ef7af78f8fd0c6f480204b435ac4269b5baf04626c73ae92521b0c061a642"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bbf90b05ccf41009779c7798f4afe9e9b7a8c65ea245170c74da1833df984f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de54de15b763907b158d9b0a1abc13192de0c7e7b4b39335620e9319ce0c3ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bf828853e7714e8cde042fbc8ad9ab8a0aeda9455c4fd9a26333782a2bc4edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ff935dbc0911bf38813fbb29aded3bca052fe7953b5bf6303a4793e859201f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3210c8019d8fb81110343513b59ceca5652996e57f00de277a9a1024e6a0fc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0170f7e15a1ce265ac40afcd3375a5dfcb8b28f044791fbd8ca10b1e67d39f73"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenthereal/upterm/internal/version.Version=#{version}
      -X github.com/owenthereal/upterm/internal/version.Date=#{time.iso8601}
    ]

    %w[upterm uptermd].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags:), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upterm version")
    assert_match version.to_s, shell_output("#{bin}/uptermd version")

    output = shell_output("#{bin}/upterm config view")
    assert_match "# Upterm Configuration File", output
    assert_match "server: ssh://uptermd.upterm.dev:22", output
  end
end
