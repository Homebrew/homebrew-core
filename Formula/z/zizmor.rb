class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "8f4ebf26fef5920c0d133925a162dd4e772c088bdbb7a4971bbd589ebf572c47"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e8ac96db7b82ee543ecc984d0480edb27927b0259b73e0f6faccbcb508f09f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ff5faa93e6c96ede04e4cf82b85d80b8dc4e1bbce9bab79eb8620e2b058537b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "596dc86b63bdebf576928bd16c84fff14b0d8177c09e1704dca36133dbfc2fc1"
    sha256 cellar: :any,                 arm64_linux:       "6c68a66fc792d771e001eb3680adece6ddd7925756982430fb8cfd179f6bb5dd"
    sha256 cellar: :any,                 x86_64_linux:      "7bc11153f31b09f9323bc1d6db2ed717573377ba402dce5a8c715422329cef88"
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
