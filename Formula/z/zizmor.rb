class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "c0e8867d7f32a9a68c62c12611c53c4d915e80adf3608c78b105c2da0bea6e30"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a13b6657f0b36205db42fa29656e5b08d19b21caf5b2c17f6d72b981f05505dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f97a93c2257d5377b7ecbfc66299ccf05248b0ae25a0be0c6981f5bd55275cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ceae1f9301b99c2b3f9cc407294e32218ecd8a7e3302082c9ef44d1d408b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "62784df3979899fa9860b0c3bb8a81c4382e66f29c801f74ffb4ce258a01fbad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee5b56d7c2d8d18c3ca906f4a19e519c193544633c7de0e37e836d6f1dd3a3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b17664d3f3e765ec6d8376d6bfe0a1ea33691cc8150b87ccb3120f52b1c9f4"
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
