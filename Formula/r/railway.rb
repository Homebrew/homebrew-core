class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.36.1.tar.gz"
  sha256 "045a72e6b08a6d1ff5a2e70b87b81d818ab58e138bbe217f5356583719d72736"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "300db25de930eb8e54961fba688b871b1a9a4289760991059d6c4600f5de150f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67eea85985edaabe9ca7729da9926f7420b3f5bd446c2ac53ea5ad1221d2ea32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce417976bd74096fd3bbd96a6c508a96cfc018d1aa7c24548ecca4d1a02a2db6"
    sha256 cellar: :any_skip_relocation, sonoma:        "604ddacac88a0bdc8c80c96f4be77e2c2016c7b5d24cbf947cc3d3bed220a242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a6a3ef2248c7f2c245144f2aec036479510bb73283964f7b543aded380fd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee5906139d877d1ff964fdf567a8231bd481654d43d9d07959983e0a40d5051"
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
