class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.1.2/sox_ng-14.7.1.2.tar.gz"
  sha256 "40a31493bd11cd52b029c4379379afc129b1e804e9105b353b5f6d7e45637aa0"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62a9ed182eacb0e8324f7df9eb51213c0e413e530f725bee21a36a10db5096d3"
    sha256 cellar: :any,                 arm64_sequoia: "c65b1b55d5e558e972a3b2c5c07ebc8d09aa73c32804b806247ace93763115ba"
    sha256 cellar: :any,                 arm64_sonoma:  "e1112090e8dfe432d71a860dc1d3998b842c0b8d6838dc566ba033cb56f92787"
    sha256 cellar: :any,                 sonoma:        "487de4a5b2d3d55be8353bd4fe41015ecb8ea253f282f16b452dbf0eeb3367b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83fe1c87c652d8b373c3015d37f3488eb57c1bc684aaa83b0144de39849b72cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf331df007a6f778572bae31dfe1e481abf91b08899cc4656b55194e771e2db5"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"
  depends_on "wavpack"

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "sox", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  def install
    args = %w[--enable-replace]
    args << "--with-alsa" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_path_exists output
  end
end
