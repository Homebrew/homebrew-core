class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.33.0.tar.gz"
  sha256 "13eb48496be1f10f043551eadc1446d0c85a31bc2a3d2117fb02d9ecd869d99c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77ee7bb2dab459b76f714518d171df225b86af5df4031c0f01656e30f4daf64c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3004cdfe52c433f52bcfb5a49dcb67a1818db81dcee7e77196f274f4f4dcdc8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6280f729e7f46f3cbf1cb66df11dca813c853527e240318934fc165b710bb17"
    sha256 cellar: :any_skip_relocation, sonoma:         "74294426bcb0cf56c2d5e0d9c6fc64b0e8c2cec242953bfbb167c29ccda62245"
    sha256 cellar: :any_skip_relocation, ventura:        "309f080c27d58389c08e37476c12a9bbed573d862d2dfa0265436c157e5af213"
    sha256 cellar: :any_skip_relocation, monterey:       "e9ca5c263dbda92abdf8770973d3b65860699a085566afde8656d1e86ded1421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f535a9e9c7b6b5ab20c06400de56730205c0fde14c5fd697553f1d4bdf11fd"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
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
