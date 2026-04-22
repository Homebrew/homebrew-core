class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "4a037cd9ccdebdcf02e508f248c5ee8656ebf024d8f29d2c458498f16fe9893b"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67ffa6d0aad32573f2781f785080e00d4711d61a3a1357ce17dbf83ab7db62c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124a1eb70746dc30d2b041bbb119fcd42caef53ed28c29550ab4bd890862f650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae29356df478f67b4bf37ce97ea5b9f314320c18a10eedca55856eb4e75a7e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "377874cf5ed39052d4be96c9b29e1e84007b60c165d5dc751a3f825b54471f75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f07b0b26650bda975cb875afc11349c482effb5dcdcdfbc70242ad3cd343cbd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea05a4847c2626fd0d4092ede9179c551ed0182d9fb1f01ef95e37ca8cf3d569"
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
