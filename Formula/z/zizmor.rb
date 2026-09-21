class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "3224fd5b49b77b2ec1a8a0809587824e3bc346a7583e8272d8ad66f95d0e8cc2"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "587f796948baa74b5c12355e2834030227b461458557f04a038f2b9f9875fbb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbddb48b35394ae644d7bee148675fb63a01188304affef8dbe1a26ebd524e93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4efe3e78a3d4fdb0bda26a556c02a4c17ebda512f70809506faa180be5a2ac4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fa580c1f57190e7d2c412e6de3b7367f2e64a3306bfffc18faa6150505117dcb"
    sha256 cellar: :any,                 arm64_linux:       "87dc567490081fd47c0f4ddd6a9e38c736e6d203973ad7c5812954026e5eb9d8"
    sha256 cellar: :any,                 x86_64_linux:      "cab8a46d72d940972dca032ed9f45e2e2816d8c5a21ae0d8dcd930aed032c072"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
