class Ropebwt3 < Formula
  desc "BWT construction and search"
  homepage "https://github.com/lh3/ropebwt3"
  url "https://github.com/lh3/ropebwt3/archive/refs/tags/v3.9.tar.gz"
  sha256 "0c04879f97c92607017c00e0afc5a4e0428a8467573336300ebf3c1a6bcc4d75"
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lh3/ropebwt3.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd66115bce6f069c5b16a3c87fba2a4e3e0a158965a4062ebba86e2f2598d0a5"
    sha256 cellar: :any,                 arm64_sonoma:  "9f099ff6a4f3cff8d08cda4f651550cc8a8767f264133aba3e1052381619da6e"
    sha256 cellar: :any,                 arm64_ventura: "4a8827a9eeb1208e28f6b81e6c075863d3db3851ebeab0ff606f34bbb32cbc93"
    sha256 cellar: :any,                 sonoma:        "8b5139751d4261dc40d196fcd21065c987cf1c41c53466b70cdb488c07dedff7"
    sha256 cellar: :any,                 ventura:       "e3626c7ebb2560e191e053f1ad58e4fdf00fac77607e5ac4ed135a311a8a059c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e746f565e4e6ad4e0eeba31edf33a40dc74bb964e87f86895f5f549c094b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd94cda69d5a156c7c72a9dae14176f3dc38f2c2855dcad7f64753b1832a4c80"
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
