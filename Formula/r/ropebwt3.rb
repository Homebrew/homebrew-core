class Ropebwt3 < Formula
  desc "BWT construction and search"
  homepage "https://github.com/lh3/ropebwt3"
  url "https://github.com/lh3/ropebwt3/archive/refs/tags/v3.10.tar.gz"
  sha256 "072231015c834d7ffcdc621c9ae260dafebf9f22ed9a780fe0026c2e0a845c5a"
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lh3/ropebwt3.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ceb1467adeb7b88f75b34df0e9e4d4680428c3d3f470731a54b89654240f0c02"
    sha256 cellar: :any,                 arm64_sequoia: "cb74b320bb47569ad99f4f971eb293f180dc16855e39fe1ff78e4f7f17db5262"
    sha256 cellar: :any,                 arm64_sonoma:  "74e7e74087beeec688d47cf60fc60f865d3c99049670b98dbe030ec00c8d2c0e"
    sha256 cellar: :any,                 sonoma:        "c0d44bb1e7c876d6ca2793a8992c8c63155a8748df7874986897d0fcf9540998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61fd03b0a5f96a969c73397d94fb5d1dd7659dd55bc791544accc4c58179777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a4f42c930c3b6bbe46d536c2ed6bba3296c2b932ebd5c793abe4742f7d1f1b"
  end

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
