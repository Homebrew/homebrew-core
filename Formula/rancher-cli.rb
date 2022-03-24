class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.6.4.tar.gz"
  sha256 "9b9eaeabcfdad7b4f47dd558f104db3cc50407743a87ffa57233091ccb759278"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f270cab50ecaed12d4e47769029d0ede2ccc2301cd2e4e805b649923e4a59b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bd759bbde9acf09803646dda99e15f58abb90deb7b2e3f58f32d87a29d34b91"
    sha256 cellar: :any_skip_relocation, monterey:       "0b256acfa11d962c970288d8b1b14103408a5ec9f953522dd2164e4d11d9fd37"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bedea13fc5ba9799aed6e9c4ca2a7ac47a3191fa09b5334e3c3b4949ad0f059"
    sha256 cellar: :any_skip_relocation, catalina:       "5b36d74a8391340c5171900fe8d293cd7801176380d91fbcb212e39d6d1a16cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0455642ec0d7619c2c0381ccb7ffe92a7b969fc5e4c805c1affbda17f63d8897"
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
