class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.10.tar.gz"
  sha256 "b1ba991bf53bb87bb2f18612420fd05c22d36fc2681159cabbfd0f04c3452c81"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8c4e229d5393626398109b86e90b33d13049b06f4c5075e80e684cdf5bb124d" => :mojave
    sha256 "7fecf7063b8db353777590b5993e64ddb13e7e594caaf1c5e939c1ea8f60e5eb" => :high_sierra
    sha256 "3e49bdf6456659e51407d258df606d230d9778497eb91f03a1efa776c2c6b08f" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
