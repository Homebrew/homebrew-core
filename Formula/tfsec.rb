class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.2.tar.gz"
  sha256 "3c55808b2eff0cb44e78bb69f995bbe9dc4c4c3211fee5681431c7207f29b992"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a14f43d212d771dc073c636bc091ae7cb4e990652741c5adb22c1309982c72b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c2c1ff73ccc9ffcebf55cee6c2c8b42efc17b015b04f0518238e8b6964b7ac8"
    sha256 cellar: :any_skip_relocation, catalina:      "1bec69f30130d7e6dc8376ab57673cd99420ee919e00c9014e6968e4527a1b23"
    sha256 cellar: :any_skip_relocation, mojave:        "77d4f52b27ed64dad1a10c6a133ce0753e1f49410c2bf3d16cdff6705f236dd1"
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
