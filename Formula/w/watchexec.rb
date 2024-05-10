class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "8d8e3c1de05daae24a31ea59d61631812b6044a74231aaa0e5a2ee15203898e8"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d49c46a24643a95b15f96d4f4edaed0987a7cea2f7c1b67ceb6c7288eda434c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b119db8feff4390a416dca3cdab129da3818cf8749e3b54b71045828946d6c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f673c4b9147c07fef4cc025c7d7fb6c77faf9617978b8513b7ca71274de62ae9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b8148e46cab6456a73efd4b00dd0022fa06a9658287468625a371a087e8f446"
    sha256 cellar: :any_skip_relocation, ventura:        "845868fc2a11625b1c5ab16f3707f8eb95de9466a3e18925c852633c98883dd3"
    sha256 cellar: :any_skip_relocation, monterey:       "f73117d7374dc6db7738d248fb3993886a94a4c8afd38391eec5d9bf9f6c9a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb5474ab4d255d609eadb4684ce4db5c9729954884bc9b7f11fea6fab539f9b"
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
