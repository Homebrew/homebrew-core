class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.19.tar.gz"
  sha256 "f25804c1e09897e42a6506fd09deb18ee7e64e5a24e9f4148a7c29f98db519eb"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b093b8541f2cfe6aa87822d8403323c7872e2607d09be702ce4f38a277c3168b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ead4a9f3639546a190f6f097dddcb45b8e0bcb7115f343b17e761be8a7329348"
    sha256 cellar: :any_skip_relocation, monterey:       "92173947f2b3da16f8fdf8c5bbc0830b47c891e83b5ec4c13e62bedf9b0ad381"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb3f69b1e10b7c52783ec2d00e56f983461cd3b04d6c68f94011a42e0f630844"
    sha256 cellar: :any_skip_relocation, catalina:       "2f16d882cd6a1401d1d91a60a769f8db0d8d3ddeb72424822f4b2500d650d5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be1bfcde574060c6ea8236ba8bb70012fba7474a011e94e84940112b0ad050f"
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
