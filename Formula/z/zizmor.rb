class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "5bcf1275c0d605ad3afe4e100fe198495b83f069e71503c71e6dc079e0434d3a"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11af3452a4ec2c9aae95a7df028e19dc3e595fe9200cc3bf9aa7a29a7c8be894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1968de00abfcb0bb85d579c52a8c8ef9a73a700594f1e16f60a4ce3846bd26d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad55796f871f24107e2abfa14f3d2f2659acda7aa8e6d380675a6a9cc75fac3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a039bcec43e17c52f94bac880223094a560723a286d70dc77c75ab77bd07c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f547b8fae5311a7458f4033f6dfbd3f71506b66029a8094c0a9e1bd48befa305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5447f52d6a6999668e42233513319c0969ae178cf276e29805742205df6bb8b7"
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
