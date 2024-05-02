class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "2d0fa4ec1cd711e22f88b3629d84c53bcc7b132bbcfcf578926f00e5363ffb86"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e880d76a13aa3e7f0ff9b3d25eaf2a1718c8cd18d79b5217959561d32e365287"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103c065aff70f462986ead00d74a4e81dbadedb4c0534fe7de6b28e12399fa16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ace0876857ab4be98c8d53395b67192fda787bc8a6f5cb670375be588a12385"
    sha256 cellar: :any_skip_relocation, sonoma:         "09bae7115d68bddb6e761c48f10b294c9c4727ae52488fa2892976470a26aa9c"
    sha256 cellar: :any_skip_relocation, ventura:        "81ce0fc5d6a489c22b5aababc7cf92b6a194eba629c18c27625838644d3cd4a6"
    sha256 cellar: :any_skip_relocation, monterey:       "4d19bba90593e03ea1eacc00b6dad9eecec3c18944f976a698edf2dc477395b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d9b57857f2229da20437efed1a8309c08e75cabe59e9c34afc6fa0e4859281"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
