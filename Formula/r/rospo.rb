class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "9e9343b60fa4cfb1507e3fc8ef3b3a30499a68081c6efdccaa4a5d47ceadd210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d08305849940711f8643241b44247256b71a5d1ade1128981fa9f4d5a309e717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe0201c29f66f23581de0677faa71d40a872ec49da490dd1fa713e55a9c14307"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea2f8be686aaf285dcf380da7b22735e79b5c94e7a9fedd73016dbe72f7f5306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec7d9c311c08955f8e1a8372d60f573469cc5bc097d4a683207c2ea7798513c"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e5d37615fa638ad35cc07b7290662d01cb4d3d52e0cac95415665ef45af84f"
    sha256 cellar: :any_skip_relocation, ventura:        "a69a35f14cfaa8c854adbc6e63b84296c756c654dd7a4d2097ea995cb8e4e81b"
    sha256 cellar: :any_skip_relocation, monterey:       "cda0568991968c41b3797001f13f568654b586993e21cefb7b87db4ae5114d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26175c47fd3098ea360818e47c187eabb8e69d0b11a220e9d282d7a49d387362"
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
