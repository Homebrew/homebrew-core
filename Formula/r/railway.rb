class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.45.0.tar.gz"
  sha256 "9cc49cccfaf818f00b979249cfd4f5d7c4b63b5cec09b51e5334b983758c77db"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a635e2a6a9f41abda5e9d0b058e9be4f0f6fdf92cb9bcc09897f522dedda90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983e6daa013d326edaf235789b77bb86f9ae8ca5e2f2e3d7fdb9418497f1987d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d46725238dfbfa2c7394d8859486b2b7426f5c14228aef848b73800a9a00015e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f26fb5225aa78d919401e4597b246d629c645ee19c7a831038c1882e150ceba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9486f6181c55a2a1ae5fea68c4252850e9ff864ee98d65c8c287aed1c1bfe1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ddbb5f6de6f32ea968ab5fdb2b9fc4b88b8aa3b73dda51c15e1de7d7006ce7f"
  end

  depends_on "rust" => :build

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
