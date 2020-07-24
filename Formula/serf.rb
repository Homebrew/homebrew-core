class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag      => "v0.9.3",
      :revision => "959cea60eab1f12f0872ed3ee5344c647ec56c7b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bd356983857810d36a2ea7c3ae785a93068a502c3c371ccbf9b5db5b43c7a77" => :catalina
    sha256 "8fc8a0b90605b7f45e55bbd3334aeedf02feec63f1b1e6d0de0ce473ad575be2" => :mojave
    sha256 "1b0dbf9abeb34aae2e0b1634f274d46b7bd95a166dfff360fe54599de68415c6" => :high_sierra
  end

  depends_on "go" => :build

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
