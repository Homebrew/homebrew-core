require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "ed036506d58826f5494e7e67038c137e6735fa4ccc199cd18c9dae3da41a46b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9adddb8ee7b857de6196943474bde44d46d8bd7c60afcd90d0ba52cba14f7702"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "313e82316427034a72fb87f93b1f4045019481556b9e5635b085c8cd345c3dea"
    sha256 cellar: :any_skip_relocation, monterey:       "0e693d65891e867ba4a09096e648ad42475a3262443ac956ec3316effd0c02d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b80f2dddb883c45e8d2b2bf92fa9cfd972bf17538b427648a0331811249618b3"
    sha256 cellar: :any_skip_relocation, catalina:       "de2934639ee130f2fc2966fd522eb5ce419c4161d4478d51b48ce791b12e29c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c7f942f9c4ec3b14c7cfca348da2420d17145717ea5f27fbc23577e70e195c1"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")
  end

  test do
    system "rospo", "-v"
    system "rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
