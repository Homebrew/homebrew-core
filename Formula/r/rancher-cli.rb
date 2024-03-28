class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "bb1e7f1eb43d90789a7330e88dbe39599f306ab97632e4dd2951bd107f96c9b2"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fd0e2ae20249ca380eccc0c90e723857ee32e562927962e8870f4d0fd8b1587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93fbda4445da1ac343d089669954ac441e9cfe2589ec3146317130dddbb456d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70edb4244f503638edaf16c429f8798ffad4778497655c3142dd3ad44caf8062"
    sha256 cellar: :any_skip_relocation, sonoma:         "b61e38c93caf23a180a84509aa58c335835c74ab5a4ade19c770abf963e664b9"
    sha256 cellar: :any_skip_relocation, ventura:        "a92974eb9b5506ae557372eef7758e4d87cb8562f6811c93a4a4aa1afa8a459f"
    sha256 cellar: :any_skip_relocation, monterey:       "be9e9f4162f846a4628cbf594e4429aae1bb50ea592f23aa676d9a0710ebb151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c586bf37183c9b50d64d7d9518f4393c21069686a5bce6bf5833fe2c516cfd6c"
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
