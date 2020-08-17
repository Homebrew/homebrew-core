class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.9.4",
      revision: "5383e2044544e9b33ced96fe75d157604c09be86"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c716a0e85a67699c6c83e3cb178ece969d94ec7aec6f36ec60e4b65e6093258d" => :catalina
    sha256 "e56b01a8475e3c056233631945ad4d3710dc746c048c09679835f795cbf371f2" => :mojave
    sha256 "fd50cd7495843099f7895ad8f0ed25537cbc853a03555a4c2bf375b2c1b53df9" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -X github.com/hashicorp/serf/version.Version=#{version}
      -X github.com/hashicorp/serf/version.VersionPrerelease=
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/serf"
  end

  test do
    pid = fork do
      exec "#{bin}/serf", "agent"
    end
    sleep 1
    assert_match /:7946.*alive$/, shell_output("#{bin}/serf members")
  ensure
    system "#{bin}/serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
