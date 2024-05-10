class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2a3988b6d94e1c41c729d1a8da1820605c570b0e88194ad726af56d7bace1b44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "327501d88c294d3c6c97ab865f5a5284353f5da4c44d069402136e9a332b8f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3635e852fff2cc7063ae14f07d0a9f18f705bb68770d2b897f0539db955e7a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1ec9994864ed5510fdebc311b0bf8140e9d1b2dcf02a39d861eb805a90c02a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "63ee9376dab9d0182824d42ed9f6d3526ffd2c598fbcf157ddacbaa30964dd53"
    sha256 cellar: :any_skip_relocation, ventura:        "efd344a0e26f2b7f1dd79b989cbb35289748807ccee2633cea082ccb7b6b870a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3869934c82b5f4347d8e86aacaf126af2cb5407ba43beb3234034876805a713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6330211428cb42b9bb88bc52824bf907fdea01d9f960e196192c6ff6d998db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
