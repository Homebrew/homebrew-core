class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://woodruffw.github.io/zizmor/"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9789dca47e36ac8c124be5856c38acfac6169839c7fb3a0ce492776e47f1d880"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ea65cdc71afa8e5717919be822456172a31a39b8061fb56041ec82d1b1b40e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45afe3145e67cd329faa3b1be1a7eea8840955881e2afdaa655cbb7d1e91cffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f94f2cc9e5c878c80dd9cacbdf8f249bc574cded3301524ea642557ff2cb8213"
    sha256 cellar: :any_skip_relocation, sonoma:        "6730852ca2acea48f89324559683c526709f92c9be0e20bba156965f492754bf"
    sha256 cellar: :any_skip_relocation, ventura:       "83b9c25537c2e30c681eef1796bd55dafc3c86a87d486807f194f78197ecdcd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a602a257efd83ca95718bd7750701fb6cf0370e4a2555b7e6a7987261ecb87cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c31eed2ba3d1f73b5f106678c548f04daad76b4f54591335d3337fdcdb17b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
