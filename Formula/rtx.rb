class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "1a565f9176264c5505faa0aad14dbce556e94a47c25861e884c8f3afe7e056aa"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "515987c627f7df98e4422aba130d040f8e1f9cbb0d0853276e2bcde71e339625"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e3a6dd263a1f5eef399ce2dbc0352d209ef754118106dcefa18482ac1032e4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92b0a37eeaa94990c7913894d29a1fa147000fe0a0b24b256dc6759bcaa51e0c"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ef157a71341cb3199f6235af61e446ef972c29d543f328c1ba046e0c8088cb"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b552d9741155dfb471bcabd110b1b2a37711e17a4c8d0e63bde96caaf864be"
    sha256 cellar: :any_skip_relocation, big_sur:        "7158581a83773e13b996185401cd5f0d00a0fa6bb7f90d2c166dcfa45c69e39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f5211f2b42ff2e7c16ad51cbba8c9df2d8903ed08763b1914b15f7c9ced840"
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
