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
    sha256 "7b232e24a80e1c0199e2b1b368f7c55e1f51ff840b450eb826b2688a2c6fab03" => :catalina
    sha256 "04d4ea4e4c299ac0899a59f96381a7f382b91b16d6cc4b7eb69d97c446e66343" => :mojave
    sha256 "22a8592c825ec0adb0e790be20dd0e24a8d5afb2b326d17df22a5266197a4148" => :high_sierra
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
