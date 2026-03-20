class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://github.com/owenthereal/upterm"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "047bcb184cc5189ea5f155d6a62780206fb01f093672e7b4c887cb7aa50bcc7f"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "567500ac5cbc11d7c20d9c49099fd10627f31ceb3a8754fec3177fe41f554599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d738f81d704f7fe9fe0e2270f3941e896b5b5cf1621f01bd58e510efe74bc31a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b6bf3da922fa0363f57c285ff60eef0433aba0b7274c6cac4713f5c1f72ef30"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1cf3e9a76955c70ea802d2960ade9694b04cc34a0b5cf49b30f9a82bc39ff51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76cdef950e66dd0f142ca411589f8eb698dae3ea7870196c1aea5a4975ac4b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8efaec7ccc144dbea8174e867ec88ade4dad38d47abc147d056b0fe1e9f0942f"
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
