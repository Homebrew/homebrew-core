class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.22.4.tar.gz"
  sha256 "c914e747170784e23964cacc99ebcfa93c732c37b7c5fe60cb154953e32f9edd"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d800f2809eaa2ebb72145bdecd65b61b2e18afa122a4fc9d829fab62915b1bda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23dd8989754c966b1c3f72de27547ff38067d579ab57283c50e46d9bc1758ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f4f2ca89bf7477f92f8963858c1d6a9fafa6e51cb75c475b157e4e3af309d35"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d32bb1f09d53243a32b948c177977800b9e2695b2251268ce749db3159d4b9"
    sha256 cellar: :any_skip_relocation, monterey:       "8981e7f5be665f71458cd6c1cb2bd20e0e0c5c17359d66a11f7e96bc5a3701ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a2c99a9b27999174050ade9ad4d68457b454aa0f1c451e80ff7d48d0b90003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a0f84a1e8a32bc5f5ff131f65ae58e5d0750d7658dfcd0d23e41fd922054dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
