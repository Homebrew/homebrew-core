class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.202.tar.gz"
  sha256 "0a769e9a351449e628c8b57d3d71e1c44dd1a68134e98b75c84c803f5c467f0c"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8bbe8a74f1f97d7c92a7209e76cdd07e581586683efb61c97860b2caa628f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d900345ecdc67fdb6f92dfe1f195c7954a6a49657774e680d704405e0974ead9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a27b00119dd7f4db52c24295b224fb95e1f6d3274793f56e4f52714d294e6e8"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf47850c31587d4cf757b1b690b1fb383ef73ec9aee0354af67dc00e7723956"
    sha256 cellar: :any_skip_relocation, monterey:       "20f7927d0372f15ef4133335dd6d6d47640b05b0f5d2b83bf7e01fb65725a121"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a06044a3422fa2f689d719ee63bb42db1bdacf5c54e8988dec4c02502f13ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c663e1c359bf10de39a14eced8b35746b6c072cb7702562f0c8d49cd14a7e7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
