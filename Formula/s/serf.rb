class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://github.com/hashicorp/serf"
  url "https://github.com/hashicorp/serf/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "9b1705247d0e325d4050b79fb4ef05db899095d20ffbbf72f23161df6fd91143"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cde5efa135b027ccc05a06d2530f37bf40fb6ccddb83999057d8f91fd1af8c23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cde5efa135b027ccc05a06d2530f37bf40fb6ccddb83999057d8f91fd1af8c23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cde5efa135b027ccc05a06d2530f37bf40fb6ccddb83999057d8f91fd1af8c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56957740c2ee1379419824632086979e5ac768d44dcf2ca45e1327a8346c10dc"
    sha256 cellar: :any,                 x86_64_linux:      "c6051672372425d9d971f60b5025d568456cd8fb0aa8854c0ba513f0ed04291d"
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/hashicorp/serf/version.Version=#{version}
      -X github.com/hashicorp/serf/version.VersionPrerelease=
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/serf"
  end

  test do
    pid = spawn bin/"serf", "agent"
    sleep 1
    assert_match(/:7946.*alive$/, shell_output("#{bin}/serf members"))
  ensure
    system bin/"serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
