class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.30.3.tar.gz"
  sha256 "fc9154f703a4946c751a40a653bd193f58eb6a6a7da0e4663b47e01f36bd27d2"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f637b71791db7b961b7b910a10ffcacba104537633789e20cebd08e19a6f748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6f2a4c20592a923cf5e5770bbb9dcc05b441e9ef73374322ff90f567809b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2a513a74db5e8360b4492b7bd0e5aea7d8718d4dfd20edb3cccf0d5a9c6860"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76c679a1e7937254c9176634ad63d071e18b83e743d896b30563180ab8d63f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc3780ec66bfc7c4f96c995523df111bd6212006b0e241fe1d79a30b2032f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8397bcce1cb9aa1f886166544179cee05c2a0f0051b81889e352e20f342262"
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
