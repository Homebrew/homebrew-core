class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "1c97474166b84ef68c3085fd58fd0eba34ea7e835d0db6bb6c7590725b835329"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fbaeaa5891ff898d8a1585ec4fa1e262ea48e01045fc7b16f4a57beb6f9c400"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb74675b61b2582c15cbe7d4ab61e0628a2857920689a7293fa001fe86e0bbb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e136daffb2234b40b4e6300fef0d1df4ebf34cb46f0e3e51e21df00e5520509c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c80bdb3408ca5a0e31217084607c785f9dc15e05f207e1f2eca44e1b59d7edc0"
    sha256 cellar: :any_skip_relocation, ventura:        "3be8a3b3b3e75deca7be3e5d96b95613eda401bdb00cce4a8cfb008fbd5497eb"
    sha256 cellar: :any_skip_relocation, monterey:       "8b7bbbdd38fd30d4886c748bbd3276b55b6bf9884272b7b2f65f4f839c28426c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd0d360f148ecaa24f388ecfbbca9a895afcba735b1d4e0a92e4f094e0fea30"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
