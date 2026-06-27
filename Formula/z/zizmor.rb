class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "ec5540b3bd6d347df61dcd24ecd2eaffd3181808f4dafc59a9c889e26b075eb8"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cadc97cafe522bbb27ca9bc5ba1896bf4292116e2982853afca526dc62ac348e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbf3f135f44ed7ec79d7fc453f9eef14a865d7ffcc2a36ace52ebfc14bf9504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f406e72b0842e9048c618a70b5a5a4bf2b29e842f089267dc1011e0b09d72bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1777529625065bdc26ab38afb8c50c5d64feb395e27155bf96c03dc055e341e2"
    sha256 cellar: :any,                 arm64_linux:   "bda6262a716adc1911e15daf02ee1f964c217e0eb8d75ae28c0b97b2427b9b8c"
    sha256 cellar: :any,                 x86_64_linux:  "eb1fcfbba470d4919cdf0766a4cd0accfd077ee104dd1cd89b8cfeda52f4ddad"
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
