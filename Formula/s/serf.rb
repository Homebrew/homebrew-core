class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.10.1",
      revision: "e853b565da00a84dadd5e2ea0dc7919250ddb726"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dc6c50f1b2a6a151d6a1fb0f0cd54b41854d8244efde532a704b99863df8a7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a8907fb429075617af0dd136dec133ef2d3db717aefdd5d34af24bdb61b8f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62db308d9635a9ea626c57583164787a63384269eb58dac7e73d30a7814032dc"
    sha256 cellar: :any_skip_relocation, ventura:        "4111e92cbbd321dcb17d6f20e05cabc266ae92df15d31dc45ab426acf8eaf074"
    sha256 cellar: :any_skip_relocation, monterey:       "93a502382f60b63b45fd43636ac8799831a5a68b26acbde13e34f1b69bc0b813"
    sha256 cellar: :any_skip_relocation, big_sur:        "35e00fc92e749a4d529e2b7828232b35addf73a83548a01d5ada7616274db7ef"
    sha256 cellar: :any_skip_relocation, catalina:       "f8711cd1c0eed5c1c2417450a5f75458f81ea4a665a8f064e3a064c2d9c70c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a23cfd0f748a6d4f52803b3ade623bb79691a217e12f185103cb93359cb1c6fb"
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/serf/version.Version=#{version}
      -X github.com/hashicorp/serf/version.VersionPrerelease=
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/serf"
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
