class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "63fe91e60ab368b6d40e3a8d7cb03226388d0845ffb0b077e45371a8635c4e51"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3cb2f0894bd834a0f0f59f1aea32df3d42e3b39837a70a0fa9213b8a6281105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a76164d66f0d87e513d899a79d4fb2bf76248b95f18014ffbaef39dc7fc3159e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b3745c4878c9cced8438d4602ba522c45bad4168bcb762b39444fba74f66605"
    sha256 cellar: :any_skip_relocation, ventura:        "78895e46408cb67ea0557727b6f3b9ca416a811f867ff81973e3312c2568911b"
    sha256 cellar: :any_skip_relocation, monterey:       "330b701a3b803a1ba611a9e151e01c243e66f43ee4c1f0d878c987fcfb58ae24"
    sha256 cellar: :any_skip_relocation, big_sur:        "eac323fc237726f16bffece87a69558d31bf3786b3e7d0d0bddd7280a2289469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5de0ecfcdf47fe0dc156563cfddb527b41e2fb82eaa7979960010b2e614ebc"
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
