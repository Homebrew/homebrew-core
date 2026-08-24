class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.43.2.tar.gz"
  sha256 "ea21ac1d2412e7322c36624d656f60523997d3d753f25d787dac47cdb67fab2c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb7b02ee4d1141c7a93c8c6fb4878e13ea69982fa73aa270be2a01cfc30c67b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d6dec34b818832131a7aab3acceb874e94cefe8bdcb57c56d1692c970bc8a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b074801ea0d247f7a7a8b8dc99397e62faf43790321d3aeb4c73643ab2bcf158"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2029f6e2cf6fad1a037842a7be387601028465d812660a80ea63ab79399085d"
    sha256 cellar: :any,                 arm64_linux:   "9f94ef64624552419036aef97e4882489551f64d4fff14eca992c6c8e6478fa4"
    sha256 cellar: :any,                 x86_64_linux:  "32f6abe4aca80efa37cae25209b853a26865f572ceb4c678d594951edcc0feec"
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
