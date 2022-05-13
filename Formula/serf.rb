class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.9.8",
      revision: "a2bba5676d6e37953715ea10e583843793a0c507"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43898b70b7822d41f86f4e4a1b5b101cbcc5187326b9f5e5008b086c9a1fb92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "448c655cf74e72e2e919ac5cbd8ca9799b3d10638028af6f475a453e0d29bdd3"
    sha256 cellar: :any_skip_relocation, monterey:       "5492c1e76121ebd5fa28d863623676360885c04e1bc3742d4cb8856b2c6c438f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce2cbd6e2ad0344a9b0dd2f19da1ab752ed4021645df4c0667081768cf58bcd0"
    sha256 cellar: :any_skip_relocation, catalina:       "bb7216fd18e55536f70a9df6d592c3daacf4b5609f3e2e807aee573189ed4a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec7af898cf71117c9569d4c28a2b82867da62374bdf497b103a246094a6785d"
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
    assert_match(/:7946.*alive$/, shell_output("#{bin}/serf members"))
  ensure
    system "#{bin}/serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
