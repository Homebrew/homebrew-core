class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "9e976cc981bb9b0bcaae766a6ddee451738821c0a26c4a3c266dda1891ae20d5"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b366957f3406e7ef8c10b329504e9fda9ea12b9cc63b8f1635698a8f5218b524"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad046931de8ab6c9028d2834413861fe2c4db828d215acaecdadd9a7997fe9a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "295130331f70647490db38701f18ab4b956fb23891d449256e5cf7f9927f2677"
    sha256 cellar: :any,                 arm64_linux:       "059684ad62b99ec4e74daf80d43ac12fdb423014dabeee06a8bc6b0862b6535c"
    sha256 cellar: :any,                 x86_64_linux:      "cb9ceacfd8abe87f18b423d9b4d66861fd8a78becde6f924e2d5efe3a9689fc7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
