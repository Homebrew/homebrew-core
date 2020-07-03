class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://combine-lab.github.io/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/v1.2.1.tar.gz"
  sha256 "10a58a22cb5b3924df3bf78be9cb4b83dce4f6a61e4c6a6e37f3a56ab8ac166f"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cereal"
  depends_on "tbb"
  depends_on "xz"

  def install
    system "cmake", ".", *std_cmake_args, "-DUSE_SHARED_LIBS=ON"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fa").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/salmon index -t test.fa -i index")
    assert_match "final hash", output
  end
end
