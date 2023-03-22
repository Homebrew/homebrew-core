class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "8e1feb5b6e7d2a3221391ddd0c60c51569d4bd8f1e12cbbcd386b54a806dcd22"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4a3c618afdc2670e1c0efbdfbeb911bac5b0180391514a570bc2dc2fd4992f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d4d57d055807e1a2f2a0f7ebdfde10195c7cb7d301597da274766371d9578e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "079ad1c30a6fb3f84d7bebadf7ef72d2347da3d8c884342426031bc7a84b2150"
    sha256 cellar: :any_skip_relocation, ventura:        "ba605a74daaa02f8973999c9e92e16ab835b1e3d7d6c546ec048bd0d953a3660"
    sha256 cellar: :any_skip_relocation, monterey:       "4510c2986cd3fe6883013370c80e060620cbc310585289c633954ce72da5954c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a89bf343996d70073818aba621601e077ec7c78a589bad69b6f1f5deb60fa049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadf4904f251148e395ad4c2b0b9b1e3689ac61167292304755413033a6aa44f"
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
