class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://woodruffw.github.io/zizmor/"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "17a244ff5a4d5ea58b323e421da2c061bb661c2e533c3827988a83cc1ed79f78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06cdf464e76734631bb7e218623cc20e4a1c79a60c48fe0214e5bf089377edd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627df6dc06fc48c7cd01aca11096ab7b9da8ed3bac34ca31c6c83a1f4e2c4bfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62e651f7551a649a71f228ac0843e737bd88079abf914825fead17114489eab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "62c2b7d26c945adbd8679498612d5ad2a52b06ba25162edd6bb40eab24dabb36"
    sha256 cellar: :any_skip_relocation, ventura:       "7ff2e163033021070d0ed7efdaf32331002df1df6b549881e672c201cc61ac02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "586d9e955b0037151269896184c4e8ca5cd8e15364abd008cfd209d24fd90a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1e45ec0461b3db2f198652a8f3a00bb227bbfe9ce929580a0e13ab13c94347"
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
