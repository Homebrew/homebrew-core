class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4676ba66c4cb8366a19d4d36139edf95fca0cd3c22ea7a8a21614040e93a3808"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a74a7ea4f3c72cf417e605344b3fae00cc23d44dc0f952848aa724f21d60459"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee7fea80e797553efea8a306aa0dd7fffef1963a989965bab28a5e7a4fb9cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd37cbeb2fd7d931837b78c2a4c9978a14448292f0cb85477635e3f37c7c0dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a078cc74ffdfee2859c252e03ac777f9c8d002e3e7b33eec964a62f4155f809d"
    sha256 cellar: :any,                 arm64_linux:   "ab228d2c6103cafdc513435cd493f61498c8233dbfcb5351b88004c6107ebeae"
    sha256 cellar: :any,                 x86_64_linux:  "00af2b4cf09ff7062e13df09543e582fa2363c7352c3252122cc06de4763e2ef"
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
