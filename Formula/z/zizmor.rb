class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "27da51a31dfb553a9fe0acfa3a129f0d5e55b8593c502f2c99b332e5f3156e0e"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc20d88fdf708a59ba08b4edc3709b33d283718d344bec52ba9880c2af8628a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae28995cb71957bb16f4842a5991d232cb4a8ffc3538cac32029e13ad6d4dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bbf3a0fff47bb899e86d435035fa1ed79701a4971bb59d4d474278ec7ead1fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0bfd810f257c9a1fd6924c2685b64977d7562e8ded9e80281d201690699880d"
    sha256 cellar: :any_skip_relocation, ventura:       "da945d8fc3c0a7ad382212c8969a2fc170c02727f04eb1aa85c4b97d96b39608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1326ed59f52f7d59c02c7bada35de97fd3837d7621f3672c5d0d27749b0df08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3dda820c1f751c1c9f5e5976b76d41c6e83789cb2b79b29bd75de155d803f8d"
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

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/workflow.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
