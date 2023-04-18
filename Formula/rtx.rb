class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.28.5.tar.gz"
  sha256 "bc463309fc49209ac286bac4c346ff20803073cda1f48bcc94eb8113df153e49"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "005eba264f20599dda225075f3eb5a01f3c204ece5018b7eeff3e28601533673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36303fe8a4c4e5b65a55dad094f32fc0e005deddf7445a8755fd5f32d2b5eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea2306a3bb33406c4d1c1b5ac31e54f1d0b92c184cf2c9a159db9b656cddfdb5"
    sha256 cellar: :any_skip_relocation, ventura:        "6c0f538059705c73d0d9c4370e541d2d2f9ef7d8b16dad52ed1b2d80d4871a22"
    sha256 cellar: :any_skip_relocation, monterey:       "df519cff91b0f89fa5077be4c286751f672e86c4572eeeed8839b887a7a1040c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b556c2cb3bcde72db1b5f3a408c874f07b9d648939d120bb6a0d96fc02550467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5290e72e2e1b12506d6040c96000f6fa20192d1a13f75e48826dce37dfd66795"
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
