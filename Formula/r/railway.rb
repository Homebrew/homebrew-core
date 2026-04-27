class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.42.1.tar.gz"
  sha256 "a6621abbb257463f593f978537736cc4ab9e929378297ab89f1f597ace5315f8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "805f9599861132f4f82edf4d191b79e5eab642771e78cc5f8516371540095946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccc9a53081621ce70881a469b5b675b13ca4d71e043c547057dc8676735cef7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d655bed1097daa79155b0c323c27cd4f23609ae625c2d8663a8cd0cef89f72d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "81e7ed63d4d284110180bdb264e0168f6783172cf99497207e039e4b58dea1ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11635420712f885f4f6aec2e5dd9a1d65821111e06b3f88d1674569a29f9408d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf03b7a62d4032cd21030ac8e3d966ef96e6df1bd94ff27d58667c4c475f5a98"
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
