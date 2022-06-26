class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.9.8",
      revision: "a2bba5676d6e37953715ea10e583843793a0c507"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93692d6fe8acf165b7862cc0fada6f54e0c97906fc65b136b7ed6780ee644292"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c14105927e4364f89656ecbb08e84543286f8a2bab84e98826cd14c11bd9521"
    sha256 cellar: :any_skip_relocation, monterey:       "0c5555b5229287270e331b5a3a1240a08980e2984546342ce0d9c6155daf9aac"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d402ab5cf86b77f3742c8efb6650c04e9f807328fb2e5e09e10e7b09e11ae4c"
    sha256 cellar: :any_skip_relocation, catalina:       "08e9a3ac7f1bd4410a89603626566f9d05fc42e197146d43b7be2717642bd439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0bc60265805bce0fabaaa924ada86adf1aacc07ef101cbea52f8acf9294f29b"
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
