class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.9.5",
      revision: "7faa1b06262f70780c3c35ac25a4c96d754f06f3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41fad17ccdb557f367e6274b29e3685ac5e208d6f74d1e60cb139d06b785b8b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ebda6b1a139cb8b900799676be12c0993bbd894b1869577739a0ef2a4682d38"
    sha256 cellar: :any_skip_relocation, monterey:       "1ef06407828413dfe572fb65df0f1950e4cba1030f8a5e883d063126287ec960"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ae109c95ab044f550a3e20702eb165d014d618198a7fbf280f9731cc02f9e1b"
    sha256 cellar: :any_skip_relocation, catalina:       "9fa6ba9a73d743e404c84088e64ef860dcf3f8e0bc0fbeb74a39437440c0dc72"
    sha256 cellar: :any_skip_relocation, mojave:         "2bcfffa14b7a86099e6dc3574f1dcece4d125b72f32d8fad6be943a63380da75"
    sha256 cellar: :any_skip_relocation, high_sierra:    "78b0abfda4b9f41da7df720f79e93346ad524450e801c3528706232d012cbadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f4e059e762ccf1d1c7dc5af1475c0b45f9725ba16e914df476d6c3b67b8e9e"
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
