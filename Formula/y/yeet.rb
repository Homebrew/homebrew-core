class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https://github.com/TecharoHQ/yeet"
  url "https://github.com/TecharoHQ/yeet/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "971be1fd808473672e752e42f305176a5732183f2386e4bc689d39937fca0daf"
  license "MIT"
  head "https://github.com/TecharoHQ/yeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "737a2f5559852831e3f8a4bc65194d16b4c68c70b3d360635279fea438f79f79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "737a2f5559852831e3f8a4bc65194d16b4c68c70b3d360635279fea438f79f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "737a2f5559852831e3f8a4bc65194d16b4c68c70b3d360635279fea438f79f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ca6d1b34f1aaa9660c88aabb0ab2f60c0bc20f01706cbd3fecb3ffa02c0fefa"
    sha256 cellar: :any,                 x86_64_linux:      "5a18cdf2626ffa9c36781889417d37d16781baf1d0c21de4439975c0da597ae3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/TecharoHQ/yeet.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/yeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}/yeet 2>&1", 1)
  end
end
