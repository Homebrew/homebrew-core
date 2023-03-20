class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.0.13.tar.gz"
  sha256 "0a2c7d313b3a07717f767f909c01c0b45cb11b780564875d59638c93d5ae98d6"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa4b859e1b2cd91d3b93e1d5068a335838a1bb1c64c8f8ee1a6e517d822a63b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a945423cde6c4e1f3df2bc6cd4835c8726e6da5bedf4cf8f95fb4a3f9ea5100b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef4653bbdb7936710739147e19aad7588ae851a88c8c68d3addba0d841906749"
    sha256 cellar: :any_skip_relocation, ventura:        "fc662578c20dd6b9ac7dbd2d26ba96c0c0291aa27cf69a72df7e5c5d9fdc97d0"
    sha256 cellar: :any_skip_relocation, monterey:       "6d708e4d7f5a5b7223c5474fc9f945aadb967229012e1305fbf0b21990fc0b93"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4aad85b46831313f1f6417651af4d0371eb1119df048e6fdcd2cfa4b543b7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78788ae832dad7f36f69b3c7d33a018c193941093ade5b16fed1b519dfd68ae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
