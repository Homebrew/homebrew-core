class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "57bc1ec5fdfc7c5456ec87ff483e8f033be38a4026cbe2045ad60f347c21cd6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36640d863f94bb319d6ada797d3b3a11c7fee7599f2166ff6271ea1f20c41094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36640d863f94bb319d6ada797d3b3a11c7fee7599f2166ff6271ea1f20c41094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36640d863f94bb319d6ada797d3b3a11c7fee7599f2166ff6271ea1f20c41094"
    sha256 cellar: :any_skip_relocation, ventura:        "a024e596642072f36618942acf35064ea1d9e84663b0e34064e1c108bab16f2f"
    sha256 cellar: :any_skip_relocation, monterey:       "a024e596642072f36618942acf35064ea1d9e84663b0e34064e1c108bab16f2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a024e596642072f36618942acf35064ea1d9e84663b0e34064e1c108bab16f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b03aba71cbc6f63e84843d514f60c8805a019342ba694a9dc691e4da28a5a9"
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
