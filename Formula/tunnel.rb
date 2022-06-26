class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://github.com/labstack/tunnel-client"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.15.tar.gz"
  sha256 "7a57451416b76dbf220e69c7dd3e4c33dc84758a41cdb9337a464338565e3e6e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5f7baf6232a8be13a17350b3ac13d264c530e40c93cdc5aacbe9af856fb060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57607af5d1084a837f6dac59d268a9c5ed879acddac12840a1a4e8f375a070c6"
    sha256 cellar: :any_skip_relocation, monterey:       "b63c0576e0a46d3177fcb0574dc63bc252885ab52840f3454eb3660f31fcb744"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb4ebc8c76b4866aeaa4da672e81e7027ffad1f4d78a7867aa1b17511827b3bd"
    sha256 cellar: :any_skip_relocation, catalina:       "8119646cdda9c9578230f230b8b9156159d9adecbf30b1c8d6fed8ddbdce54bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a079e012dffd514c536355269716695a150db0dc30cd3ea2c27aee789615805"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    assert_match "you need an api key", shell_output(bin/"tunnel 8080", 1)
  end
end
