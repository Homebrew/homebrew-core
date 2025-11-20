class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "52201822ab00bfaf6757f953f667870b3aada52f887813e94b4f322f239ff8fb"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "423334539a1268d82b70ad4dec1b78e1bfea6bcc882d6e69be9cceb22f525927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d44b907cdb9d86013f5babef6630af9cde63b1b5c82351c09ef1be9896ed09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af528680ef4aad89b586bcb983730f309a22679416fc24547bdb23260802df74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c49fae4ca20c900082e02cf04abae83e1ac7de54c9c15e9f2f713bb1bf20e616"
    sha256 cellar: :any_skip_relocation, sonoma:        "c26e55deac8cc1b2b257789dc5651716fb70b06f8b803c02418f172912cfd16a"
    sha256 cellar: :any_skip_relocation, ventura:       "9f3948eeb908d473788ac19ac5c8565890bac51de3d0c14eb96daf71ecfb843b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd1913aa10427b3c7c0a61d40449dedf6a9bc3f7f3b53354f7530f564ea3f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6672077573dcfc793f50053879b75e7e7c30f7e81e05b1b7350c105183398c92"
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
