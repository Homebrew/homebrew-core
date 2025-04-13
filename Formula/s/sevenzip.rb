class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2409-src.tar.xz"
  version "24.09"
  sha256 "49c05169f49572c1128453579af1632a952409ced028259381dac30726b6133a"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af70077a765a3b8932830f8ac0bffe756ab09a01e9c4f1cceaf4b6ff67b73b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43517abad06c408e8e4d3b9d49d7984223f3181d44e9c9582ffd1be047fb191"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2a07519bf07398a2b7a2837561bc672240b7718df55cf94c4d788039942add6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eae8b36ca70c587255c68afcdb34ebebd616c7be3efd7b40facea0bff43ff826"
    sha256 cellar: :any_skip_relocation, ventura:       "604cd24f7bd8da0e64d6c35cf4b747544af1e720f30946967da1697b3599c915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0edea6848b6dc589e06bb0397389e202c36c83665c624b1b21169ce3271273da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0cdef8851bfaa08e67e779e854b4c063cbc619e2b4c844baf04e12594545957"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read
  end
end
