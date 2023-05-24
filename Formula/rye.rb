class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.2.0.tar.gz"
  sha256 "2c5860b9ba8cef089e2c4c6ea8482156413953e1f8b2e5248a267335ef59854d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf23ab2ea58407c80a139fb795e3921e89818d03d2564e558feda5e8f998ee8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73cb1e9b1a9aa8596b0cdaa8585b9ac54258b405fb4d53f99393d48f3eb6932"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49bd7bd27362f76a62a74d875c4ad51f97b280b1e1bc3c121fb31f0d672b561"
    sha256 cellar: :any_skip_relocation, ventura:        "de38d16e5eb253f5621982bfcb3390fc491f0458234b9eaf2ebb1b3546a862e4"
    sha256 cellar: :any_skip_relocation, monterey:       "068e485d66630c03f14345abf326a9fdd10f44ea41284988bcd56f2b1eaa225a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a513a4ef2a8c1cb73fdd8f93f467e7964996f941233fc7691e78ac2f34e12d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3288661749a9b0b8ab5e41be0b6fa05537cb46270a611758777861af3f4d2384"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
