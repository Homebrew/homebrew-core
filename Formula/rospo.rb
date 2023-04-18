class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "275645d216b29b430b1c65bc7ae774492a31026c3ac8424a7dc8f278faf3c334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "800124e15fc97854cbe9d3c0b7c9f0568b4411b6c8c190b272ef6483490bcd38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "800124e15fc97854cbe9d3c0b7c9f0568b4411b6c8c190b272ef6483490bcd38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "800124e15fc97854cbe9d3c0b7c9f0568b4411b6c8c190b272ef6483490bcd38"
    sha256 cellar: :any_skip_relocation, ventura:        "4726852ca874eb6d8f59fdab7d89afcfd554d8cfa47c27912dd1611c8a841ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "4726852ca874eb6d8f59fdab7d89afcfd554d8cfa47c27912dd1611c8a841ffa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4726852ca874eb6d8f59fdab7d89afcfd554d8cfa47c27912dd1611c8a841ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a8b5e66e552b7ca6831712fc1e76adad068a9d159780b876d2f0059f42bcccc"
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
