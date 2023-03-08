class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.22.6.tar.gz"
  sha256 "243a3b1da5f925b0887ad3c279c88d7a8a4eb94e951d37012b33b5aa0d70674b"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff6deb2eeae9bd6702d69df34ddd7207ad76d38239310ce80889a1cc9526324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f3d2bd46c61b280c354074475ab55286681042016983ceebb021c019dd3afc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11eda94f3f7b5e146de8539209bd9125eaef11a9650356e4ed3a5b9d2bfe2096"
    sha256 cellar: :any_skip_relocation, ventura:        "e3e7c17b21e33b2199f2fa8c854381a0a4a21fd487435838e6be05fd3ff7eb8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e3ad1202a322ddb6dee12f303640bf1e67c37446bcf1525091812b00ac6892b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "063a30d258d792956dd12a8a32f51e722d427e2d478b616df65333a9683c8f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c0fa1180b2f55cfeea890a7f0832475cc515bcd73c8e61f095453c24d09093"
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
