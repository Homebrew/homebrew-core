class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.77.0.tar.gz"
  sha256 "eada3042d4fce8092324e051b4beb8425054c29b35f25d31b1668b0b05576c65"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    manifest_sha256 "efcb85ff660495c5ec9721ecdd74352662b4daea22bc89d5327cb6c1038995f4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce0ec16d585483ab0110f0a5a97420c19cfc2f9df2527bfdd5cdf413359601f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9216adc16e8bc2c8a058b4e914adb2700b07ea35a123846f9379a73450964b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bde37b6aaab0e58fc2c6213165472045009355fd9f95e899d86e5685170ca5cf"
    sha256 cellar: :any,                 arm64_linux:       "da9141083b2d9b4cc5ba00095548b2b8e9efa3e582df1df33ab22a722b180e2b"
    sha256 cellar: :any,                 x86_64_linux:      "8aa13e6f64247e0c4ebb10dc6b6a1a122c71a27d5eb1adbc89475a22ec90bd44"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
