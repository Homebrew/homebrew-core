class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "a0a8d60e0d4c0a93a0fe5e781809fcf9c12d278c2624123b2ae2dc9fabbd63e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a38299addf3e2fb0de87abb726fb40dc629af9d9b370ba656749efb7490e87ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38299addf3e2fb0de87abb726fb40dc629af9d9b370ba656749efb7490e87ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a38299addf3e2fb0de87abb726fb40dc629af9d9b370ba656749efb7490e87ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f39e941e155718d2e6033d946952ac1095321a206491ca3908af8574e97187"
    sha256 cellar: :any_skip_relocation, ventura:       "c8f39e941e155718d2e6033d946952ac1095321a206491ca3908af8574e97187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3e69f483e95ffa4457f8a0f9e68cbbd313c864cdb24c316d729f8ed5693c33"
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
