class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "957e0a7373e02c561f49d66b0dfc7e0e7b4576d73f149eeb01c0f15643d358f0"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b51a5f0bafe29ffb54ddfe200fe555285f181e2150519bb6f4deec43fe914c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4f339e6bc5d380c960ef491650b0ca8a6681743be93629d7f1ea878bbcb826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7ff5e7a6296e17af9fcb563bf0ca40aead2c7e8936559ab5c3f1db5b1bec57"
    sha256 cellar: :any,                 arm64_linux:   "8018adfc23809d6360682422cac106c1abe41d7aa357f234d6b27652b633888e"
    sha256 cellar: :any,                 x86_64_linux:  "01e59243337cb57a3ae3ea33a141d0fcb3064fc2fba4d79ae2eca0d2151aeff3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
