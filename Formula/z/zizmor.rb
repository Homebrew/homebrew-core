class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "32fd4ef7b42366234e837c67985de0a09e46a0feab4ac0036ed0dc2b9044cbff"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c930e762f785f6894942afa861ae78f5bce013d7871ee81db3fffdc91352b919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23fda1b0956a8d9ebf0f4cc66a7adf82f1c2ef13ad1fba8d9cfa617fbf4c38c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8607dd5a1e59af97b2b58931287d38be1e07e8c7b9be5c7aa6ce4bb1a9e5f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6809299b1091c38d712194090142800169ece15cafd3217e4bf4b85e9620ee93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef58d1f6b94b32953bae74d241daede9d8820eebae1b6de0f9c945a1a1be5de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8be98de4621ec2a6d01512cb5a8d9746d9d35d487b57c422175b3da747c7ba2"
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
