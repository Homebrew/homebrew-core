class Rmpc < Formula
  desc "Terminal based Media Player Client with album art support"
  homepage "https://mierak.github.io/rmpc/"
  url "https://github.com/mierak/rmpc/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "86e6b465707cdca82f53aed2a3bef600430edbf4e626124d194ac346ee989cbd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ac81f0ee228e0acfef6aed122bce3a4023d8ace5f3ef66c3510e27b6daa4f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65170c1de50cdf688114b04d71a52aae3a9eb3948695456d8655b601f4bbbce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e74c3d9c24cacda3e5dbe004da099f7c8be18c6af91146e40e574b194694d3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba6f7ffc146738447a8625e925a2ad9e76af9e262b76e576336c78b4a657d30a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31cca7cc0e3791389bc4a1867a8d357b42cbe1d8eac3c02e2f6036c66bf63514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb1671395a83312a54e5c1ad1bdb5d0dd5f4e495eb0fdf536d91e6b8df2e4d49"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/#!\[enable/, shell_output("#{bin}/rmpc config"))
  end
end
