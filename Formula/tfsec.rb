class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.4.tar.gz"
  sha256 "791322da015a3f1e5741e3e06140c65a87e90564b6d36bee2a29207ab45628ef"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20529c26bbc31284830b732ec67b7651758a7777934d43b1bdc4dacc14e64ccc"
    sha256 cellar: :any_skip_relocation, big_sur:       "edd789c52bd15229a798a5106d49cace01fe2f8f91c6100e1d7fc9200fc642ce"
    sha256 cellar: :any_skip_relocation, catalina:      "e977e169ced7e9f3d51c72d03b25cfa1789a3c4a9c87c62924b2d39b6004fd68"
    sha256 cellar: :any_skip_relocation, mojave:        "ea24b99c2530e0cff04a76da294c83a115c2235d8273d7ad0ae65f700f4f5037"
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
