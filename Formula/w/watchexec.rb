class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "8d897bc79d6e6a381ad9b3abf2a4967b58bc376bdc0aa418bb99829660d74aff"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75be379c9aa8871b4ce898fd521096d0a5a6d7fc9bced2cabe3ec50befc570db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e4f94d48e8aabd6b059c80a4409f1d8027802c2b4c0e420aadef139d40eb3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5543ac335fd13f470bfd5f9358f3fb8489214c842af681f694f1e3ac173c229d"
    sha256 cellar: :any_skip_relocation, sonoma:        "849422c3aab90635ee80292dd4009d318e024e01af1d50474234b87553e2fc00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aed30ad1caa5855cb2201813ce45fd9c073115e69ac9ee2a7d94dd0a9d24e612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce8ba4c24a30e15a5f1bc7ee98a6bbafa952324136936d841bacd60f46c11e9"
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
