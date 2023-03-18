class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "5a7ebcfee1b38302cd2b2a33245a1d2f7fb91257bc28134296cb3247271b4846"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "415d6917c8d2a43a275f93b511475de77a616332530556cbc085862bf8e0cc36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6f23b9330744fbc5b26fd708dd02f7379ece653f1d331fdde7c7c31891c235e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6a4bdead2642138ba703b30f7c50d7fa1321b38a160f26e0fe4c22e1358e2e7"
    sha256 cellar: :any_skip_relocation, ventura:        "a884016325f07ef56b12dcbf6bff0211645925f562bc256bef904bca0768cab2"
    sha256 cellar: :any_skip_relocation, monterey:       "6f92cbbf1af9e83cb1578cf7c8bcb9baa0f9040d06c1fc030fbe45ff26e90573"
    sha256 cellar: :any_skip_relocation, big_sur:        "db271cb37b975a1fd3b99f4074f05541351afdae308502cd993422c58eb5e3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1454abc110e9b1dcad097cd3bd54e817f4002e864497147fa41a71eb6890eef"
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
