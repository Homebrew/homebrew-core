class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "c03e5060f832069f3e32e61e8fb3600e6b9c18fc68829176d5fcfd53a86481a8"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01b2d0cc11294bb6507fbfeccc4b902c9aaa7705425bb6352e5fe754c1a6374a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fb857cf7fb7402e6677532af9ce7757611e2370bf0343cad952333b304eb11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204e10275587b48bd04c1c33283a6686d7ebb5381c0992cd6e3577016eb448e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "70ab9ca2e6824e1ef42aa13c59bb8584c1093084046165d7a7b37f905e10ba7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b1ddf69cdccdbc84ac41efb97db43b736821934b16068016604c2f8733b8d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff3495e018244cc115e1596d104fc1577e2b1f4d9fd2198800299b9e97a2adf"
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
