class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "474b4b1a07e871be7ea1b530c73770fa9a04d153a8d9ff36b87a65f374d83bbf"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79aefb90a7267f36fd2c44d8f00c14539dd76039a0cee5980d7ed0e9109fde24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f73ab21e0eeb3bcbf5983d5fe7ded7a2ade98725761757e4947cf1d2516f5c14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8fec5f24018fab225c4a3c2cc14d4f50ad6c5b6bbc56cf73d5ba7cffbd69b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdd48d6cb13dd7eca916d245b39de518a2c20aad8d2b375a9c5eb1434902b491"
    sha256 cellar: :any_skip_relocation, ventura:        "dec4fee39defd7c812c18fe34693b03e7b8b9c625b1453135239c417b2d09d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "86ef06a2d8b9fab4721c2d3137a5280eefdbfdb671e2c41de6ff49a9b98aa1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0957ff4cfd5722eec7332c7b70c7eaec352ebaec053544735bdee832bc028687"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X git.numtide.com/numtide/treefmt/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "error: could not find [treefmt.toml .treefmt.toml]", shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end
