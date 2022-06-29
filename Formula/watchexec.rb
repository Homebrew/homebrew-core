class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.20.2.tar.gz"
  sha256 "62e2e722a84475436286010edff36c56c4c6fad9e76be4b35381877e93faeac8"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66507f12309fc37fc7f081853d3aa37afb83df3a3e3fcf0ff3a4cb93b0b9ec5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8461208fd41e69a9f4d9668e30f8f468cbf4e2a8293429b064dba8779f719c97"
    sha256 cellar: :any_skip_relocation, monterey:       "2795c0f9a3552780b9bba112d6deb290a5ac003b6b050155acd6afa4a0b69716"
    sha256 cellar: :any_skip_relocation, big_sur:        "d086791b0e9220a05ce2b017c90757324bd46cdf6913abfebef3921bd2e9eb25"
    sha256 cellar: :any_skip_relocation, catalina:       "144de0109bbc3614af5527d537aef3865d6cfd21361f3fd551aebaf9c9487802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c886e0845d06cc49517e43082c5126a5fbdabe94d18f962b1ab4da5d35b3a4e"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
