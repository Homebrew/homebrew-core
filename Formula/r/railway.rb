class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.37.7.tar.gz"
  sha256 "8fc072fa7a00bc4749a9fafab7c3d632bc2e869b4d0935dd5442e76d6e0a0734"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720aeae0b075097f7bf22e52749d85893fb56222bb79806358d6fe46659f3fa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fbbd31a41f2ed85ef70deab2541a5d293e7ddfab8d11b806d89e5ddebea0896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898d9a780818e41a434df49607aaba858dec4f172075cb30d44a2e3b5ceb1ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a4d536e44a10a5c4e54c90309b9d63c2c012054de6021b9a1ab7275610ec8d"
    sha256 cellar: :any,                 arm64_linux:   "f612a0450413d237113f747cb1dc7cd44d39a61affb781ba7dd06b98d2facc01"
    sha256 cellar: :any,                 x86_64_linux:  "7ab04ecad9eb05c7c0faca22ee3ea94018bd5f4c8febc88412aa1cd039e881d6"
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
