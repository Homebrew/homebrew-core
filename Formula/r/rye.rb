class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.13.0.tar.gz"
  sha256 "d5f3e7dbb8935ade2ac02be11c46b241660873763652f0416f40b975bbf3603a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e6a8da3e86c35e0d3a77095c20605ba6457193c68e41b00ecb2b9aff745b81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f401872fd688127e6503b529baed24c821b3e9fa7784c49bcd4e6c8c734ed55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ce5691e88da7e285f0d84356a18cf1af6f90a4c38d74464ace8bd52b2671ffd"
    sha256 cellar: :any_skip_relocation, ventura:        "a8e7a5926db65fa6fa225e73673c85c66b64e3b7c1b3d7a49aacd52ca9077e05"
    sha256 cellar: :any_skip_relocation, monterey:       "35ad2964da4e56aec8c1523fde687db9d5c84046d47b058b5c233663652025fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cedc38e2518394259306eed7459af31d7399695c8e4f988d254bb90b74652d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca5585f5c3daa77576dc3f1200695b0cf4e9cb6a7c9a979ac8368dbdd891c0a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
