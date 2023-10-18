class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.7.7.tar.gz"
  sha256 "7966fc9ece587b739ea87d38f8e485a5f977f02860a17666c2272757609f0d34"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0984b46781ee90523046fdea0f5bcab1f9a1f9a34120c2f3ebaa376fe27b638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d469b4a27d8345033c9b2ad61bb787be41d0a1131e414a54df126b03ea4667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69022ed541a95a56a4f84454a4e32ebe5277e2c0881f7e65d83c761656c39fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba2a775c22da041b53bc2173429a64b07339dad2fea09eef7c945de8b6402efd"
    sha256 cellar: :any_skip_relocation, sonoma:         "09858770906856c740c97833c055c86179417b4cc715f75890d61d7387c83a97"
    sha256 cellar: :any_skip_relocation, ventura:        "92a38b439d4e05f8ffe39efe981bf86720553c7304dce0f2e525b42f2c1be341"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd669562605bc66d2e90394d90b564cb642ef18fa87d3ef28e4303a3a50d84c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7efddc3685e4808c3cdddf6b10a8797e7c87479907201fa51c187b0125d61b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d6b5e1f4d1168fbacb27affcc829086322a7f9c122737bc6e5c2e8c17d432b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
