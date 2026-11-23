class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "a31b5fe6252d58fac123731de4690bad14740ef61fc98689c4e9c91ce87b5a2c"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    manifest_sha256 "c64289778fa26b898846c4daf6dd156980fb1c2f6f4a4b910a2efbe7c7b300fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db9cb37b917bf0a4fed5852e7b7464fe63c52c67373fd489a9644eddb276dd00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83d66f8050f7ab8e72c482cb3bccacc152c931a6d93af71cfaa1d7695eac15e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3135d526c7d556972674bb5ea8985dacb90511768c6a3142e4cf0263a4c961b"
    sha256 cellar: :any,                 arm64_linux:       "7069e03547c9456224751fb6a5d127cb4bf995399ac9679e47279bdd6588777d"
    sha256 cellar: :any,                 x86_64_linux:      "19b5fe138d5359603d2f0d210fd8848ddf497043fb0098f60aa09a621323f8e7"
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
