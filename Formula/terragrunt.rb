class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.25.5.tar.gz"
  sha256 "ad39da4705530a6b041db05062fb31c31893c8b0e801198005d1448149308f93"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f02ff3636a77cd7251f631a91aafd20cc8afda80947e797b632e226180ec4be9" => :catalina
    sha256 "c30f4427ed80b9407064c493dd4a1dad7873cd705474e5d8767a434c303af033" => :mojave
    sha256 "aba288655520419e41edf5457b719d053b04659e6284a8531674547f4e164281" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
