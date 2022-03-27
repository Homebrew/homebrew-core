class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.11.tar.gz"
  sha256 "bdd5af45ab7e5981eed25ac09767388aa1fbf711a9d286bcb99884464980af5b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f110d746277cdac084514c84bd51a0f45d5d498b10526c5b0ccca667783d95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "419c4b06beebed02de059b280de1161b3f4da91f5621e31a3bc2e2e82ae3c1f2"
    sha256 cellar: :any_skip_relocation, monterey:       "0a0a4296b45e1c0c07cc492c1971f626ab1180af1885aa15a3cf9efd75398066"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee46348eda72dc9273591bd5d96aec8a2a0a82e2333e61ed8f4c00b74415c54a"
    sha256 cellar: :any_skip_relocation, catalina:       "b93ca2f1ef46be49be0ff3cbae282711c886e1823ff1c152011c241ce70b2ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dd3d166db7f75c42ab6f0846f1dceecf44e783239d0af6ab09b72878e68a99"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
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
