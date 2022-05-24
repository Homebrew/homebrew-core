class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.20.tar.gz"
  sha256 "d0349ba4e8956a045c6abd7fdc47481dfb3c514f4d5e57f7c4480bce8560c359"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40eeb287e3318f7f39a1d728e360c18b8929088d8e9b2ce5edbbfd4b0a224a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8722d3307fd0d952f5f8f095ba35e11d5e60fcc37a85b9ca5acc2760ee52045"
    sha256 cellar: :any_skip_relocation, monterey:       "83c1367879bd9d4fa2905c733423d6d0ac6741c47b5c4299495043867c4fe41e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d11a9fff83b27e61d288e23ab23e4b118cb9401fe0790cf00156ea3a7ec9a312"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e807b98e1fd3db9e65646f9ec8a86889aade0c9447d279e1199b435be1f3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3af048a2e8b3627f6172c9990c95ea9fa70722ffe449e603afed6f588c997de8"
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
