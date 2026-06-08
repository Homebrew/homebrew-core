class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "b4fb6ffd5b0a41a887dff9bf76dba7e415132d179a95022a0ad1a7577c868764"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5cd8c3b083c929f4e12794e53919088e604dfb22ee94bffc08b3b4efaa64b2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da47088e7a5711074b766b56b2b6229088c2c14748c654356b56a0f29f46f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5118f6af3216543eb333b7c29a235a984ef9512179d5ccfe14283636510d1880"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d06905c492f5486ee41ef0ff560d34a5c65bbe3b20e28a647e4850a4ce08a48"
    sha256 cellar: :any,                 arm64_linux:   "962ef70b410b40d5296423f7e62f2dce9a8fc895d623254ec9f76d1dec63e002"
    sha256 cellar: :any,                 x86_64_linux:  "c433cb7fdbc2c9ac0abc6cec9f5f990b6286db477a05f350fa986b4f63f7e075"
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
