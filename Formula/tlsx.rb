class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.9.tar.gz"
  sha256 "036fb003412b05407c84424311c59fb4c41a63b63ad5300f226e5fa4fd7b439c"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e8196e076dd126fc2f078fa7378f1778dc23ec299178996c49781bcc289dff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8196e076dd126fc2f078fa7378f1778dc23ec299178996c49781bcc289dff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8196e076dd126fc2f078fa7378f1778dc23ec299178996c49781bcc289dff9"
    sha256 cellar: :any_skip_relocation, ventura:        "a09a767f3b3858caa877296238d78e4541236e41d9836df62656657df36d1ea3"
    sha256 cellar: :any_skip_relocation, monterey:       "b93a72142bc63f50355763a1da93d1275bbbf7d306810346ff9f1be2f10ffae5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2bc2fcaf32c3aced3d526f37524bb4a34343b08ad150706a584428e48de85a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77830afc623f7bc7c0ea4ed516e30983ddd6c74231e8b349a51480e82c675f81"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
