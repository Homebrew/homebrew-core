class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.30.tar.gz"
  sha256 "52beddc07283396c7fd30097dc2ea37b9f1872eee7f2d83546dc93dfe644747e"
  license "Unlicense"

  livecheck do
    url "https://github.com/alexhallam/tv/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)(?:[._-]release)?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f767ffdd3274e903487c26772d9728858846174a7558c4d8d6c5d82d6b02d93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ced1cc0f584974de24949023ba0fac33091616ef3fac7f518938de89c86d1d03"
    sha256 cellar: :any_skip_relocation, monterey:       "0adfda2b71895f3963997200aa5d8ad3f262508729a7135a2ea9fb00e47b50c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a48cfc429300d2484a4f96dd7a997347e7593757b20e9d576cd62e073aea7bb"
    sha256 cellar: :any_skip_relocation, catalina:       "9b51e1ba9b6b27314f0d392d136d34cbd5148f322dfc82e6e92300dd3bb8c2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9e873c0d5fddb922187101c10a9c9b747eb1cc66c2443a297deafc58334927"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
