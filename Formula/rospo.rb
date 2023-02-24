require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "a063af8a72edd0efd5fb60b6fc55fa54a0b9ae3088188f794b1ce92dc30af27c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009ad8a39f455fea11d7119c6c76b0ba509ab3e047df2d87f2d05ac22645dacf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f2a328c5d0cc0de48ee4c00c158ba12dfaa21b965ff33ff71e2185e891128b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4402e5dfc8e98d1977f69e90f6ace738d175161cb14cf15b2269817f92a98695"
    sha256 cellar: :any_skip_relocation, ventura:        "eaac591a12e166b844c9f7e8dd9d5d63bdb11660275849c4c3bc3f0ad6a2ab36"
    sha256 cellar: :any_skip_relocation, monterey:       "968070fd38a26188e86e9a21c02b222be7701c22603479db791cfe41c99dd390"
    sha256 cellar: :any_skip_relocation, big_sur:        "82ea119e722bed79de83b6072b3049ed61c6c0b8921738203a59914ce7328837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a3e4ba9f67ba28f57e8feaa110dab475435d226486883a7fec5bbc53d4f2ab"
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
