class Stu < Formula
  desc "TUI explorer application for Amazon S3 (AWS S3)"
  homepage "https://github.com/lusingander/stu"
  url "https://github.com/lusingander/stu/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "b8d87203dcaf1ce55193afc28a3c436db98a460348a58a89e14b87449a76c1af"
  license "MIT"
  head "https://github.com/lusingander/stu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d065022392c7e2d23fb3077bb0f333dd6c3e8ab26bb9c752d8feb491e0ea8581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5409f487177a6e42b1759571eb091ee416a91f5800413dc4b8f1799b116e01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34fbfa7497c3f3d900ad72ab42ab7011a6238da60d92e2409ad3fcdf5ff81f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b3ec43700cd54dd558f539fe1ccd73bc73bb5d567c12f56367bbc442137a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77e3cce2235ded9200c581494f98c6e339c9bf3ebf04e8ac3a3b948786d9a714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec9ab241de817515a51fe4f92d51b0c36fd92c1f3b67e1db08970a45973c9c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stu --version")

    output = shell_output("#{bin}/stu s3://test-bucket 2>&1", 2)
    assert_match "error: unexpected argument 's3://test-bucket' found", output
  end
end
