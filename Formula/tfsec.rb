class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.14.tar.gz"
  sha256 "7743943fc555c9ff4e76ed61c2f86f041b7ac088852d47129cfc60b54b45838e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c264e19790b6032fcbfedd570cb872ed9efee3d98d55bf57bad8509f55f9e7f9" => :big_sur
    sha256 "3bb42be81bd154467832541d24de0378f372ac98cd18605501331122ddf84850" => :arm64_big_sur
    sha256 "b738ea0f2eb82f92effdfaa386ec8d6a904e37b3231c7c0cc3f6f8df6b0ea7b9" => :catalina
    sha256 "88d461ca5e1fed1367b2f7639296aebf4538c8a60601592356e475c635a3cb35" => :mojave
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
