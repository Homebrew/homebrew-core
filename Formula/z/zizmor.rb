class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://docs.zizmor.sh/"
  url "https://github.com/zizmorcore/zizmor/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "d4eb078dca55b8a2e289a9a111639c73a2b2b725d879f5ba8c809038c3f254bd"
  license "MIT"
  head "https://github.com/zizmorcore/zizmor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a86ba7ee1a152b72a75685523724136cfaf6f1f00f0153b579858ac603cb762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef767e1ec514d506c637f461692eac71034ddd935cad22fe74129e593b90f46a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f970a10b80c14a9cea57c77d6e08c2751993e9ad772e58d28bc87e1dfdc43e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae412bd6a8d2443c1643be7526ded4dd890afaa870a55613393232f443b8607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bf78a22d5ad52c299062be62ad4c946991c60cc2bbbc6fcea5147910bf23e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac286b9b85f0d11397fd7e15e3c0ec11951d16a0c92351e906f5d1b6e3b1e297"
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
