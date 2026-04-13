class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "eb225abff51692eeb578195ad876f9c5da00cc63f56c2e6c1f58c3b963c660a2"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "803ce1e30d1b5b29b72503236a9cffc46541af2faddb3eab959b2529b8e0d32f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da76e9226a3450e01dc213b426d7d8de7acb749e872c9e80d5129af80332cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3cacf0a0ed712eaf77faae4ff50e3c5d6a444e7fb3914a4c20705f02f8d7fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "debdd7227d7b9c2103caf160b81094728b2806f088f301434fcf8d7a81208da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1518b69c68db93539b2383da0b22e14c9f5141b41eb435e18cddf39211c67ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f216597d9ee46218ab34789ab6bb18d4005a4000ebbea2516bee2f058d80fc95"
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
