class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://github.com/hashicorp/serf"
  url "https://github.com/hashicorp/serf/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "14b667203f34dd0a2cb54fcf863cd91799268f8b20230ad893fc36c23a1c7a00"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405fa10a1160c4be7af2b49daf1e8695ec698e8083c989fbe1681b75ddc70278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405fa10a1160c4be7af2b49daf1e8695ec698e8083c989fbe1681b75ddc70278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405fa10a1160c4be7af2b49daf1e8695ec698e8083c989fbe1681b75ddc70278"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbcde3482f611e66d3a4c341b3831881a9003f071f2a2bf6e1646598188b2595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbdfdf4b95ef7c5cc9ce92e8bd465b7c950d74656e3ab0c1e93e409886db705d"
    sha256 cellar: :any,                 x86_64_linux:  "4259471cae03202c99b8a6368dea5bc3772c513753c990380013a2a7cdcb6764"
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -s -w
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
