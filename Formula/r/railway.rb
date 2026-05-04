class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.45.0.tar.gz"
  sha256 "9cc49cccfaf818f00b979249cfd4f5d7c4b63b5cec09b51e5334b983758c77db"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "533ec42021eb9b7992d4cb5e7705caff042967b85457be86e81b83582a866928"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526898d4558e247a1db1f71753a1afcea3d2da711c0d14d9cbc24210728f9d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa68b0eb0ec02a45075e15be5c653bc1e51dbc4a7a70e2efdad066ecba138e04"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0cedf6a47a4bd40d838bc2c4815a3bf325fbe6765d6723e7af2fdfaec27d8ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656e2a79f623b627c5a98a62f9582a07fe162b0dc84033d65eea19dbd9f9e211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d641a9682b8580d1151660d814eeaad2cca58bb2c468057b255147fa2ec6bdef"
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
