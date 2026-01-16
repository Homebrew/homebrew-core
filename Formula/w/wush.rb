class Wush < Formula
  desc "Transfer files between computers via WireGuard"
  homepage "https://github.com/coder/wush"
  url "https://github.com/coder/wush/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "77d5a912465d1e8ec478252a9a69a04d39af75a126ac9ed94823f33a60b3d8f9"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bcff816d0e78213a49c749a5053ad752b2d3c5bec1d8f3ac838352251c167d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f21f69d5bc1c8bba9a85150bece42c5a97fbf473e39e3dc7c5dc5570e65e2c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ed64c9cde89d6a856e98bcb0509660ada93f676254560d12df8065e127de7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2320aac31be8d68acc3218db510cd3f91be381a695c01e5e8b6f9046e7569e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed8074f45bf38496a93c58f184b791b36e47363fda9c79d10cbd9bd8f36235b"
    sha256 cellar: :any_skip_relocation, ventura:       "d3e82478484e85ab52dcd10f1ec7cda04fb09f4e3f67d6a497c2ba3d50ebdfef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260356e6d21223007286d84011a0ec629ae7b18b9be356cc1f67a4175183467e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef23622648237ddf0eb3829977a5137e06d4741d953754bb55029d2855ad96bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wush"
  end

  test do
    read, write = IO.pipe

    pid = fork do
      exec bin/"wush", "serve", out: write, err: write
    end

    output = read.gets
    assert_includes output, "Picked DERP region"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
