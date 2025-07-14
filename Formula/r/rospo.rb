class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "098c84c2c6904761065aeb7fdacdbd53b59fa12cc3d0368f1ca1712993323efa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ba435c179d319f9a69ab7ccb723016b6ae62c530233cb33c657439d0eded78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ba435c179d319f9a69ab7ccb723016b6ae62c530233cb33c657439d0eded78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78ba435c179d319f9a69ab7ccb723016b6ae62c530233cb33c657439d0eded78"
    sha256 cellar: :any_skip_relocation, sonoma:        "0421d64f7b8d2a15bf72950f9f0d1ba9716c55a78f76a6d6395a19097ad116cf"
    sha256 cellar: :any_skip_relocation, ventura:       "0421d64f7b8d2a15bf72950f9f0d1ba9716c55a78f76a6d6395a19097ad116cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "530ff6c3733b5f2ef745c4aced487c64a5c86baecdd28bf70d520ef2e9d090bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_path_exists testpath/"identity"
    assert_path_exists testpath/"identity.pub"
  end
end
