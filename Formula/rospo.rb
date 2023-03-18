require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "eb5bad62d6856f9efee695d45f77dd31937a671232aa1b69e1f204f8afc36bd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d4e71dbe8dec585d79a38688f08ca6e03abd9d198886dc88e6e17072557073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8d4e71dbe8dec585d79a38688f08ca6e03abd9d198886dc88e6e17072557073"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8d4e71dbe8dec585d79a38688f08ca6e03abd9d198886dc88e6e17072557073"
    sha256 cellar: :any_skip_relocation, ventura:        "b3109a81e5a1c22594d188d5f8f6d13422f8c9b49ebada32f61068ea451f6c98"
    sha256 cellar: :any_skip_relocation, monterey:       "b3109a81e5a1c22594d188d5f8f6d13422f8c9b49ebada32f61068ea451f6c98"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3109a81e5a1c22594d188d5f8f6d13422f8c9b49ebada32f61068ea451f6c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b249190ce545b8b83f41b9e07ceecbb3121f2e344c38c54933a0c9eca9b043"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
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
