class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://github.com/labstack/tunnel-client"
  url "https://github.com/labstack/tunnel-client/archive/refs/tags/v0.5.15.tar.gz"
  sha256 "7a57451416b76dbf220e69c7dd3e4c33dc84758a41cdb9337a464338565e3e6e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e55c3ef84669231471ef0111b6f0d59b989a40a780def3d30badda873bb5374c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "847dc0c5ba0c3db3aa8f83cb4af3632bda3fa9bebd5a6a751c0d93a747575f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ff186e3d2a8616aa808392dc79c60676e30ccd766e8841aa2d7f6e23efa84ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bd84b399a3ff97b60c445f54dcc918c98fd1804bfb4fd4ffbf0c2583fa6327d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5f7baf6232a8be13a17350b3ac13d264c530e40c93cdc5aacbe9af856fb060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57607af5d1084a837f6dac59d268a9c5ed879acddac12840a1a4e8f375a070c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "34cf449aea4ad5edcea70888c68936c178616ba84cf809565036701b421b9562"
    sha256 cellar: :any_skip_relocation, ventura:        "10d71f8a7917d1f09b4292bd74c0bf9b71191ecf2f771b16c4272c8825a82331"
    sha256 cellar: :any_skip_relocation, monterey:       "b63c0576e0a46d3177fcb0574dc63bc252885ab52840f3454eb3660f31fcb744"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb4ebc8c76b4866aeaa4da672e81e7027ffad1f4d78a7867aa1b17511827b3bd"
    sha256 cellar: :any_skip_relocation, catalina:       "8119646cdda9c9578230f230b8b9156159d9adecbf30b1c8d6fed8ddbdce54bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4718f19cf9adc078564221a450b1b8229d1aecfb0e7b6e1cd05c26eaf9a9d30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a079e012dffd514c536355269716695a150db0dc30cd3ea2c27aee789615805"
  end

  # `https://tunnel.labstack.com/docs` is no longer accessible
  deprecate! date: "2025-02-23", because: :unmaintained

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tunnel"
  end

  test do
    assert_match "you need an api key", shell_output("#{bin}/tunnel 8080", 1)
  end
end
