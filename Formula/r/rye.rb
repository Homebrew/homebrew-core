class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.28.0.tar.gz"
  sha256 "12059baa5e1c2beaf0035c2e33022021cb7f71c928abe9b85098b626b230fa25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27304437648a56a61cd5c953b60932e0791e03f2112f873c0ac634f486b760cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51f48197d3fab55e7c2957eb6f568a3dfb450ab4f65bd5bbe0a997090d8789bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8db37088c131d172bc984df579a5e807e0381504c3ab7f7ede260dc4a798d45"
    sha256 cellar: :any_skip_relocation, sonoma:         "54fb00f5e2449f33e8fc89b5dea013d18ebf7736a5ba0642eb5821cf8308057b"
    sha256 cellar: :any_skip_relocation, ventura:        "7c98326e2fc5db83e5aa19104132330d6f48d277cb9e52cd1b9c5a3dc26191b6"
    sha256 cellar: :any_skip_relocation, monterey:       "e1daa6de72f58e72e1bfee1dd1571f76192bfa7f4b309219aaf0de7a33388190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46248da40be7879bfc52b3129e3667c9d187f2ca31b28b674f587cd5702e5595"
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
