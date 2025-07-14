class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "e60c8c280bee3b3a7eba32a961f6aa23d229f7a9db754715b7c98362a7c6dc7f"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7333ece7f00e1dd057379fa4787fde98ef5d2182fe146ff531cf41d15d7d6dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f45322dad8aebd296a98dfee16a4261378e6eb333a27e9dd4ec762f127edc88d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0153acea633f0bad010f85de6f51482df6d56d7121e7a669e0d4940885d7f956"
    sha256 cellar: :any_skip_relocation, sonoma:        "d63b1f5418bfe1a824125e5d3b938c253a68902b2f559791d9bbd8f252084023"
    sha256 cellar: :any_skip_relocation, ventura:       "23c8e4a1ea8700441dd93d60401fe8023794b67358c2c5da0e4027694e31df64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169e058eb5261cbb32a03b8a74d4321eaaf29a086fdd34ef5aa8ce42f140c3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee3739dc88016fedb0300b663e0e184b065b97d8bcb4e4cc022cafeef03492b"
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
