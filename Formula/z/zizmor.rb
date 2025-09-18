class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "1a59d2678ab901173de42bead03bfcadd22ec3b0c9208ebaffc89ec63d088434"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "881cbf089db8bf0077b576b4db29ca156e93b394d4d274f29df88c880413daf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69fd1a3743413769743fc9827e98432b2092f47e0e70b7ba59f81dd4ad47b417"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc59a27d268a633cf6f2d312190512bc27f360e4b7874184ee0f913e1a52947a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0653e8c013f8e8e1c77f1823efa0886997d6fb4852fab9d211acbf45acbd094c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3896e2edafb5fb4bee9c862df92f218b5c907ca0dfcd6ce5824039d8083216f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef7bf7274585bcb7bb6ddb75f2ca24800676e3c8c676760b48acb913c016806"
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

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
