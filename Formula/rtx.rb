class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "b80ad4ca17f8a90397ab0e93de497ddd7fb71832ad94b189a77226a3994b22c8"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b49502a7f35f1cd914f1678e93254053240e625b62430f09d4d22ea4999a2b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5e47430a004f7ba5b6748a605424dbd34a86c088c67a8c838090a1b1e388ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df119c7b410a12b6dfe12a23cdc0233342242c4cae0bbc2165d45a8b07e5ea92"
    sha256 cellar: :any_skip_relocation, ventura:        "713254cebd87931bf5e8bc5c2a5f84e34091eb48cf6a0df461c6142b9efab72b"
    sha256 cellar: :any_skip_relocation, monterey:       "08cd6a7febb88cb0c66f611097e19a8d88112f076bda0a17ddc217884695ab83"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8a2641ae2091160b3e2265114c01aaac1df47826f3b4032e7f8c51653c9a2a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78aa8fe5868063479c499eb2aca0a8bd56c926efd595e62791233e4a63807f3a"
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
