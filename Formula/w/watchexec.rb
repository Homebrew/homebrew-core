class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "9609163c14cd49ec651562838f38b88ed2d370e354af312ddc78c2be76c08d37"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b2099fd7fee4e1b02d2091f7eaecfd19d89758d2f12974950a97efd0b0c16b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf698bebc5452bd68db10f3a806b4bda744c02ce377f7be06e9e1adea6691a8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b778c5d18cf834339cbd62c9c58b360c0cc6ce799bbe3ed4bf92c9041221b3e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "69469573d5c73d7c6a526590226e9f8597bc10a71352d355e0ccc1b7ae86c2d6"
    sha256 cellar: :any_skip_relocation, ventura:        "c674f2407b650d0a79e33b0a3cd656a58ac4c12897a3fe3144370da82b202429"
    sha256 cellar: :any_skip_relocation, monterey:       "8a480d1ce474dbe35fde74081485a5704da54bb129f28dbe936da9ce7051b1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8780192772e258808e09b0c91fb101f94be5a4c6099b18c049dfd1a7c03ac7"
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
