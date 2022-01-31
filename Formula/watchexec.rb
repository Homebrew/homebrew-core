class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.5.tar.gz"
  sha256 "ae4b2ab209e342c981ab186e3581b95f7c43856aef037196747b6e4c33f8f3e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cb8cfd6390c28b51cce6e47e01fe8d0ee302593b35e2e2e795a3a1b369e3e61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c9bd41b036d8d67f01da2a803362be64bb805979b9c1b7e4049a2e042f8a969"
    sha256 cellar: :any_skip_relocation, monterey:       "c579f14a80a124179bb959405fad4ccbe650f47e7c49d34c8945a19cbed32c0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "35bc4226cef624986502130f12de18ec6bca7f47562b9a71cbb35bc4f2eef756"
    sha256 cellar: :any_skip_relocation, catalina:       "9c40a66eed43e5fbed1d638dbbfddd83484c6d1069d5eebac144eb47c9abe956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3970dec058993d9217f8cd5c63cf410db334e2b0790f8ccfa16849380eb3ce65"
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
