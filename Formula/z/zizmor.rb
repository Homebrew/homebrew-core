class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "88c1b2cee85c7cbb3482bacce1b5721bb75ddd7701c37ac23eb0e96eff35bb69"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a298c25ff18133c3d9620a52362a47b01cdcf1fc58992145b2693fc9ef168a87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8056124f6865eb094c9c9d858875f7b922ebe645a5167bd7dd2f20d4fadba7d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a28b426d4894c26235bee0300bef94cebfee97f3087ab14b9e3f98b565be6df"
    sha256 cellar: :any_skip_relocation, sonoma:        "386d8c11d8aae9666f934904e07ec3c57d3c0870826ec415bafa79d2776dc8e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1155743675c24c408588b8a98964e419fc037de34737fe0f088c2f475aab56e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f214e14d24b640545b1030731a27f531765c8cbd00a174baebec8ed1cf66b49"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zizmor")

    generate_completions_from_executable(bin/"zizmor", shell_parameter_format: "--completions=")
  end

  test do
    (testpath/"workflow.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 14)
    assert_match "does not set persist-credentials: false", output
  end
end
