class Sickle < Formula
  desc "Windowed adaptive trimming for FASTQ files using quality"
  homepage "https://github.com/najoshi/sickle"
  url "https://github.com/najoshi/sickle/archive/refs/tags/v1.33.tar.gz"
  sha256 "eab271d25dc799e2ce67c25626128f8f8ed65e3cd68e799479bba20964624734"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4472a3191002f70094fb8bc4356ed355a05d141439be1354b33693c8bdfafcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8308015c2c4e6f6dca8a7e24996a0f75cec75690b26c26b1bd0bca68abc4df58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "969833aabfa228fbbe0914363ac07b376c317410b5bb532bcff2b712ab59c98e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68038c77f837ba7f1beab356675cae487b9d85cf31c2b9ed949daa07a46708f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a94828e78e520c5217f5fda4dfc8ac427367e3fc306baad03aa34e03f7f223a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b822b5c393959eb2946ba1c0647f004e4197ab6e0cfe5235ec70aa9365a7bd"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    bin.install "sickle"
  end

  test do
    (testpath/"test.fastq").write <<~EOS
      @U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII0000000000
    EOS
    cmd = "#{bin}/sickle se -f test.fastq -t sanger -o /dev/stdout"
    assert_equal "GTGTC\n", shell_output(cmd).lines[1][-6..]
  end
end
