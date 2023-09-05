class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.8.10.tar.gz"
  sha256 "2248800db8fd22f32e4274e426606cb985c759b7c0bc9414b569136b0ece7431"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e97eed812e2dc57f9d3362c9ed368583a851bc6c276593bdf6df17918beaa855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "133bd0f196624d8380fdec49216b1bbbe96c192be9087133cade7c512ee40557"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdc7c576b93896a8aaf4209a05bb2213554c94a9b179b44e85effc99875b1596"
    sha256 cellar: :any_skip_relocation, ventura:        "66fdccbbc330ec9db468ea80f5bf32bf5df68cef4ed6196ae864ac07e4ce7c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "65df7c6111d7cca154f261a350b50f54b18ca87d1c3e60c6357bbafc521703cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cbc77d09db046ad0bb6022df836240a38c4900c4cca0517352ce2b8a9eb1c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f4ae509f4d461f3e37bf2a051bf438727b36de05cab5cd740227d83fd0f5dc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

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
