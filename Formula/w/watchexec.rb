class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "bf508d3662fe85294a61ab39a3fbfb0a76f79202448fb3c038a3003ae3e18245"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa53c1ef1baaddb579be96276e27112a0dfc1b6c4a94b9b1705374bcd6ac2b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eca40e4685304a9bee6e74ceb1a9956b89efa9f3cd505d2034669647960c84a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5efea623009bffb384ccd5ddae59dc026d37abdc50b7cad1e5bb98c1b3196abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c605b28916e0f5407ec4783bfc1daee9a2385bb0fae5152198662066757313f"
    sha256 cellar: :any_skip_relocation, ventura:       "09e10b76ffb038632dd20849a5cfc281e8b2dba743da7c652d2ca0d2f8a94f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "384647f2841f3697e90aa1372af3f72c4c91e28838db0162c23005cb0f92b6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8bdfdc0f5469876a233b5b139e0b3490e4f91d05eca047dd7e759c5b201b4c"
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
