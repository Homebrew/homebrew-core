class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "ebb3e3d63f8b85a74efaaa4f17759999a3622a8e342d46ab0102710b55032a45"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc565c0077526fd1745140fd4f3da3ed333164dac0d23d3346fa11e06c88d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2479120accf3c8cd5fa06f357696f0c68ad3a9c53140fc7872abfe106fd93969"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea38791731f6a9310bc454cfac54a19b265691423e5c2708289b9f82540ae7ae"
    sha256 cellar: :any_skip_relocation, ventura:        "03608e66ee6cf42e4d01051fc8a4e6f59fd900f3274338d03b62a6ace4810775"
    sha256 cellar: :any_skip_relocation, monterey:       "c900bb3222099674de268cb776d9dda517a891873406d2437dec78c9fac1a929"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d8646a97b17c29dc47e82271ef8087ced3ff0cb2bd9ac41d7f7517c3800d962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9300e8c66600495c26d0e6e7a18687d69eb5a3da24378db25a0e36c523858fc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
