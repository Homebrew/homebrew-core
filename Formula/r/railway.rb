class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.5.3.tar.gz"
  sha256 "520d767d7dc3010f0df45ae6dbe51b1d4cad7f91256c21b7af6a147a33c88f6f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c56e6ffe4ffd14f3f4df9f10dc1e6af83f48668c57a81e6cc270a18b0212f256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c459bb1a540277e4b4f4671ff0296d40eb54c52269bacb58a7a95e186d60362a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05f61f031dbe2e8b6f0cac5c9f5a0f4a0e45eab8c8cdb5151e44dfa83e0b5fe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa45d8157c665f09cf7f455eeb6b75c0a1a5fbf29897406200d6418d4d423df2"
    sha256 cellar: :any_skip_relocation, ventura:       "55616e28b1132e8470791c7dc2c367e0255084c084f6ee5b8807cd29591e62f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab5b2d6365e508f04fc38b4c2b800662344720fb04f76ea2ce9c77e44b1bbfcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95c1a8f37b7105ce0c35aa9e609e92576f891d596b4fa6c9a47f5607a4d4ffe"
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
