class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.37.2.tar.gz"
  sha256 "d204d1e1163161640926ebfaea3047de3b5b2a4d546b20532739971617e7877a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d92c146999c766e93446e6ac6547deab4620d0a3e06b7da798e38abd1df9ee18" => :big_sur
    sha256 "08dcc753a822be95c875e8ff72b97b19da983107cc6d452bd7f421702ee46740" => :arm64_big_sur
    sha256 "58b35ac931d88b4d1ae04424ecbf1377ff414d5b03580a4e370e32d9bfe37241" => :catalina
    sha256 "c752c13c831aee61e8f224cb4d275d63b386fe34f479b9ba0cf234fff72d3649" => :mojave
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
