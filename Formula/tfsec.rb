class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.37.2.tar.gz"
  sha256 "2cf70cb7674eb5ea5d7c06a892cdfc764a5a0ae23fea0d1beb5262d410838cdc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a347948cee69ad7bba4227bdfa36376974747f60580ac59d2281c16868b062df"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9e67d0e9d76160de2971478eb8335a66f7b3d12fab450efacf0f123ebef7476"
    sha256 cellar: :any_skip_relocation, catalina:      "d633f936964fb737c1fa7bd1b4f54916d5ae9edf4e73aefc1f6e1c9861b42382"
    sha256 cellar: :any_skip_relocation, mojave:        "376ffc12ae740bb9b8f0ed83f1f471b5a701f1b5dd0130f9537f8dcfec3e22c9"
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
