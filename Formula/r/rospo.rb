class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "9016ca7afacd107e5f330cac9827999cfb88ffd2c3c5750b1b20b4dc9441fbf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11a2d08a4cecef42916f83697ff87772fea78817570e1fc9c8e862f072d7b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11a2d08a4cecef42916f83697ff87772fea78817570e1fc9c8e862f072d7b9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f11a2d08a4cecef42916f83697ff87772fea78817570e1fc9c8e862f072d7b9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b199cd2126cb02f02e5a945b3d0427add807f1352595b5820503628f0f5809a1"
    sha256 cellar: :any_skip_relocation, ventura:       "b199cd2126cb02f02e5a945b3d0427add807f1352595b5820503628f0f5809a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8cda6b51663e37774ec54506f8c206cee6db50c65f71e5be833278fce51409"
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
