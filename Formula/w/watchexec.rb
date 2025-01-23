class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "67845d1c07bc47f74016cf93e7f7390e193c679003f97be7ab1ca95acf730380"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1832b603e742d621403b4febc56b4c5fb5591145a666c3f925be5f49e5a7ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a22462b45ea66b9d5d320b3da416e35ee561aa3c333d9f2e4173f1959cd8b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87be6e150d6c7648c2da65cd950080267d9a7b8a6bc154eff077c0ee321903cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "716a9414e45ed33cb46148c20216682ff9bd63cbd450eb26e5ca0b05e3524c0b"
    sha256 cellar: :any_skip_relocation, ventura:       "491b8173c169323578c70a2a093d61185c59bfe63d43a5f0e40f81c53f5f9a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36137e653210c0895941882154aba3870148cb1c25f5d412feee6d696415ac62"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
