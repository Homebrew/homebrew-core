class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.22.tar.gz"
  sha256 "61dd6d3015dd8a791deb7e356ef0adb6d3f7ad861a3bce9a35cb7b678ac19a37"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "791d91ff928ebfba76d5357b22b376c7405fba8b3721da22fda4906c2c9be5ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d473c3dd1e12a37b35c7b2c2832ec63371e8eafe322dbed3ed1c6256f8ba96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a168fc9bd68c9b9ff836ec1d49bc42131decad4d86169d4642227870153ddca"
    sha256 cellar: :any_skip_relocation, ventura:        "870ecb9bfc3dd9bea31a7628cd1ef6f72b5335faa058225cf51474f871491688"
    sha256 cellar: :any_skip_relocation, monterey:       "b52f410f80017bdf9d601a3a53b6dbf3251a828e7c77e71d9edb69930b0d1a9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc373b94ffcaa575c83f390273fd12dd258e1989c990c2b09ae86cd268a3e153"
    sha256 cellar: :any_skip_relocation, catalina:       "64d7ddbb8c44c6864c77d15b3627a3f686d8736e93090b19a7ba10abe558b1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5696802c7ec0ad4293051037fdd625f1a7d4d0ebed84307ea997b47ae74031"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
