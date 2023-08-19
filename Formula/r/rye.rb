class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.11.0.tar.gz"
  sha256 "7f423034a141bbc0e3987728b1c8efbac32deda72e5065927be48b0656f83e82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e78259594e74bfe0c996f64610eff4bdabfd9ec0d67df8806ef3c6db8b81a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848246efa76cc78f8e1d2e6fa0830e30095de5bd0b0cc6edf8d00c89973c02fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9fd4599adae10f76f5825960b256481b18f8c78e71fe224b26268963258489a"
    sha256 cellar: :any_skip_relocation, ventura:        "20f6a498e7f8cb8b49c34b095d52886e381b6f25918d355948284c3844263a41"
    sha256 cellar: :any_skip_relocation, monterey:       "1f273cccaa5c21697fe483a7dc33642b14ba024717ea5197706fc6ecc4bc219a"
    sha256 cellar: :any_skip_relocation, big_sur:        "65c1acb81dcaaa5e2f9519f13b77e1f0a4301d79f5b27caa17f32a9b74fa6a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25bdf9ce900061ddbf3b51291f017d50c69f0dacf4fc91c37eff18a8884ba54"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
