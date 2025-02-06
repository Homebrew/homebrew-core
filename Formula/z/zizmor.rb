class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7fee5244723fd3da8b3211fc0edf1cdc269cfb7e36221c411e409a147b4da211"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a18ec5c62402d5b51b5a490f3953af36712c10bd3ab5de93fba4d36a92b3ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3f35a0853d48f4a5ca5340fdf878f00cab3c3206134dd39ed525d2090a5cd2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8c87f5422f36f0d540bc3851e2c787b3dcb38ff27c7b10ff12d76c757e8c4c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2128447f4a2555677bb90d09e3cdc7ba0e19572862f60f432070b1cd19bbf0"
    sha256 cellar: :any_skip_relocation, ventura:       "d8b8537fe5f5d5ead789ae2dcb65175ec246d3b9e66a505a89c0fba29cd1c0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "206da440bae67e42c5e136bca1063d9109af31cf92f8848402a22ac4504b1945"
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
