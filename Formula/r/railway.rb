class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "dc237d08b18f26efa33f39504be010fdabc2ad7201cd8353d133c9a6eac22be0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0a409c21462e324e46944047ac18a488216d42124bbb20e2de671963553272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472188eac749c58a935f3284549a2b67a9a00f62045b0db826d8197c2dbbf702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd54c4518e311536736f7cb025453cb067dbccafe2c2391b2bbeb0694e472b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "db3d763977e91e90f319646620cb25aba011d71b84cb94a83242fefe2a839983"
    sha256 cellar: :any_skip_relocation, ventura:       "6ea01a87e2acf520f5b9792bddf45386aab378d68c5c0ed1a2e963284be172cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f2d02c1b42f081b3533717241e10080f988842f75b78a9cc6d5a08757e088d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53888b39b34889997adf17ca14995f398e02420208c2ae49506f9de49497160f"
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
