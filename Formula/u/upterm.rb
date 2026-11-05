class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "f5d5cc664b2859e67cb6437206daebee28b14b4a22be8fa3991e9a8c809b291d"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6dfdd19c29b968c5bb58eb022eb81cfde33f778f1a3337fdb24787a3aff6a9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c759623c5b837db67a7437c07100d2d8701fbbc3f106dba471e7539fbadab9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6252f27b825d0de37ecde1bf7f901e22766e72b5205de63f0fa76bb0f388981e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd84bfb75e3f11339e21957457722045aafe6a8cb02a2cf73b97197167b8c364"
    sha256 cellar: :any,                 x86_64_linux:      "b377d628ae59ae340953bf73a5c8123e95c554a397790e4a9d33ec5d276524f1"
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
