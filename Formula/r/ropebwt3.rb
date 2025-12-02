class Ropebwt3 < Formula
  desc "BWT construction and search"
  homepage "https://github.com/lh3/ropebwt3"
  url "https://github.com/lh3/ropebwt3/archive/refs/tags/v3.10.tar.gz"
  sha256 "072231015c834d7ffcdc621c9ae260dafebf9f22ed9a780fe0026c2e0a845c5a"
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lh3/ropebwt3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ace7d2899e8a64aa7917729d3843310664a273b0002fb11661b3581bce6d8ff8"
    sha256 cellar: :any,                 arm64_sequoia: "2816087437f9c04c81fcc6f922bd1f54bac2a6fc67b2bc120fd5b9c5b9c91f81"
    sha256 cellar: :any,                 arm64_sonoma:  "3ffad1259072183a1c758647620fd36759292ec78695f9d5dcf0f0ca46fc0001"
    sha256 cellar: :any,                 sonoma:        "83d407ddc0073d0a31e78816dc6c550d95fac2b12670973b7a773c6933b1938a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37610d8215a2948b8b71bf5e88bd28c95281876cd4a1a5858cc466722c397286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a50533ffbe4aaf7262926a560ce95c3dd9eff4bf387566cb14872aebe728983"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = []
    args << "LIBS=-L#{Formula["libomp"].opt_lib} -lomp -lpthread -lz -lm" if OS.mac?
    system "make", *args
    bin.install "ropebwt3"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      TGAACTCTACACAACATATTTTGTCACCAAG
    EOS
    system bin/"ropebwt3", "build", "test.txt", "-Ldo", "idx.fmd"
    assert_path_exists "idx.fmd"
  end
end
