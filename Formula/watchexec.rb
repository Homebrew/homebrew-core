class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.8.tar.gz"
  sha256 "1e450a8e13ccbddee86b9226798a513ea960c396a73d10964d224270f4843d4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4873a6432c33935956fa4aeb9cc75ee4f9ef7db4923230d9217224bd14e02755"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66711c62d7b749deb9e487a7d25704fbb55036efbd23fe82b3319c1f68307a94"
    sha256 cellar: :any_skip_relocation, monterey:       "38af8519a3aaa89e95527ce2b5f992be418112e309680b18fb9252f104022e5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "daf4eaed108be14133c82bbdbbc465770a40625a41a8bef91e0d2e8c41e4ca7f"
    sha256 cellar: :any_skip_relocation, catalina:       "de417f31d1a0eb3525eef3644e0985a87115c19f28efad60159879b8a37f9604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4b5aa35d7c27702e8004d9a738d6d8d764f78e20a092cae021818e2e812a6c"
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
