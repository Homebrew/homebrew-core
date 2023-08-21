class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.7.0.tar.gz"
  sha256 "90c6345263d36580b5c6fc7eb7932ad47c438e09e01fc6be80cac27073e19761"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb3bbca755757fc43c2fc4e61743d53123202e9920121d4e2d71ec6fb890396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbcc9707997701fb30257de8808959c1d17b3ce30a7330dd0ecb82ada8c342d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dca5a3c31a9e583bc3344ac97a1a8ece975a793451098da80791d959e48ee18c"
    sha256 cellar: :any_skip_relocation, ventura:        "dfc8c88aca0890bbc192d0344690f998a8eed87c96fd61f43bdf7c42814e4515"
    sha256 cellar: :any_skip_relocation, monterey:       "985c82bdf3f7f17ca2bdd702888115793b13d0798966cf92c668d3c4d65b1c3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d75a614a0b563f7be50623b7c204c2ce098113ddf7af7bc77b704a5aff84b4f"
    sha256 cellar: :any_skip_relocation, catalina:       "64902d60fedd97bf942ec0004b0a4c1aa2d1e1f026f7a010e3d07d12ff294bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "520bfa3dfe24f0d9570210ce6ffcadb51ae24d3c75c9254f027ea22f17d0fa4a"
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
