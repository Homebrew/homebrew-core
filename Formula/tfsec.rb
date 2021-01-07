class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.11.tar.gz"
  sha256 "6a8eb979de3815a6702b5dda2176530e7e16bc13bd244e62d420579e9ee4d12f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8dc0f3c4bed705438c27a83139ac837410c81300729ed2a6dc10fa0e2583d741" => :big_sur
    sha256 "448b2db67f018909cec7dbee800c507d5fa5226a4d75bb8ad29c27013ab37d8e" => :arm64_big_sur
    sha256 "2817724ee161f0dbd90ed8bbb8758d0419425b196b5ec0cd7d90370fea761e42" => :catalina
    sha256 "1635b24a6daf72e43a28c5efe885d7ea1ebae2ed07ba692cde66e10e1f757d25" => :mojave
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
