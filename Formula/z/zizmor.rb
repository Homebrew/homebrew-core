class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "23407c52ae6c11ccb4a2025a911de5d406c10e089c3b44957d0cd015b1d5525d"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    manifest_sha256 "e058f65ba4b9bbbda42c509c404caca3dea38b70364de1b6843797e4878e8045"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c48cc6cc75509f34bacab7d908a98414006d10a416f9f2e008d2392c9471c0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2426bdd3e9e7985eaaf1517abbceff3d0eca4a320bf1a49586bda2627f7b4b2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c208f14ff3b793f842591b08a4a87616447e4ecddff2f87547909ee75ce1322a"
    sha256 cellar: :any,                 arm64_linux:       "5ba294dbc107da0379003012e9c817c7f21c4542c247d29a3459289e6561d6c8"
    sha256 cellar: :any,                 x86_64_linux:      "48932ba7a3477160dc8702de65624f152e149dd3e6b6a92ecbf966fb9363ae8f"
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
