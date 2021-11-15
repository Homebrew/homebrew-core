class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.13.tar.gz"
  sha256 "4a1aab7193f2e478b12b1000f17f2a8e3545dd5521a140aa90389afdb2ff8357"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21e24f36638234f843db051bfdf87f5ee8def86345ec38d8056485db5abbef5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fe3c03e1c7389f3aa03de802b23d60986c61e91ad275353984effdd41055b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "877d8cbc3cbd6eca942292c0655f616d685dd23876e5e50960f49007f106eaac"
    sha256 cellar: :any_skip_relocation, big_sur:        "eceff7f2924ce3aa42e3e5cb180b38eb41a2747321d29d6d2588d0b17d5b20cc"
    sha256 cellar: :any_skip_relocation, catalina:       "d99b09b8067c46c3bad171bfa9998680a2a13ae658641be7c6fd0830f37a8642"
    sha256 cellar: :any_skip_relocation, mojave:         "f231900ea626c094b98f7620e12921691fe1f86781a66033ae9b07cdd2721bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22314698f65e0c5af34ae3fd342ad57ed052cdc28a684245620a9e1ee364ccc"
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
