class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.25.1.tar.gz"
  sha256 "2e3978da257eaccf1a53ac6323f0a60b98fba75ac3e891db6b4076f8022b7633"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01110d51f8a3a7dfcb91879ae7dcdba59e72536cfc7f235c6391cccc4c632265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01b3e396b2c7ac4788ec2ba5eef3535f7c253bece43e9bd597a6c9819eb8ca53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0196d63bf58f8233419d9df09ec73e8cd1026eb20d83e4f26e07199d80d71d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e68f7325c7ba00b478d703467333db5f87fb43ee4624db8405b2077ee58988e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a7081a52d3e87513dd03f08548cd641f3dd9212a0bb56d83fb34f732e2b061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a775174d9dedf8353e30e32322eaae54f93adc8a2b8bb6acf57c6429cdf105"
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
