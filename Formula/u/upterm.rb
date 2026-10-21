class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "1170d81987ce39480f88d8ed893fe3eceb7f1f0ff505732fc67f8b10caebe520"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53ab4fef39d4a52bc95c9772f7a751f7011a1d4e409745cb932454e7eb93e635"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0a19fa4d88dcfff01e6fdad6107c0348e68678d16fabdcda11df843938e7282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02f432046a246f9176fea13a1ab180ada58d026c1ce792e9d50cc0ab1acb6d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "865d4dce2acc2c8746bbef22e79d28c0adeea2de9d525fc3ce934acf244aa04f"
    sha256 cellar: :any,                 x86_64_linux:      "e180fff3ecdea163ad4b039864b59a81edaf442d3272d14db7ce2a5e1fea9ff7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
