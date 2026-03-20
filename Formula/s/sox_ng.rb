class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.1.1/sox_ng-14.7.1.1.tar.gz"
  sha256 "88720ce6c7701cb2c4e55f5437d6a5a2b2670a628240b0aeea63597a20ee92a0"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d80db1ad9fc0f6a376f8f71c7273715519086cd404e49f60497c5f6ffe267572"
    sha256 cellar: :any,                 arm64_sequoia: "a32ef07b233a4ae5f0e2b9866f7d7e00815bac19d2702ef2cea44aa6b38c668f"
    sha256 cellar: :any,                 arm64_sonoma:  "710ed999426b1fce3090551fa85ef441c758e2e183e5808c8267e573bdb625df"
    sha256 cellar: :any,                 sonoma:        "af3e19bf6cbcd0f874f0db9cefb664b7f4a189d414b56d8d17e1749c7435c05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb02f4bb523f6450d1f1f14f39f89581a9a737b0d450f3919fceb1492d95e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4892dc34a0afd77547aeefb3debdb46fb181742d55b620a1907d9e749ad6e33"
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
