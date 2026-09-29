class Racon < Formula
  desc "Consensus module for raw de novo DNA assembly of long uncorrected reads"
  homepage "https://github.com/lbcb-sci/racon"
  url "https://github.com/lbcb-sci/racon/archive/refs/tags/1.5.0.tar.gz"
  sha256 "41e362f71cc03b934f17d6e2c0d626e1b2997258261b14551586de006666424a"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "spoa"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bioparser" do
    url "https://github.com/rvaser/bioparser/archive/refs/tags/3.0.15.tar.gz"
    sha256 "950be627244aa4817d7ad58abcddaaa0b6cddc74b05b7ff3f4c4b51f792bb7b5"
  end

  resource "edlib" do
    url "https://github.com/martinsos/edlib/archive/refs/tags/v1.2.7.tar.gz"
    sha256 "8767bc1b04a1a67282d57662e5702c4908996e96b1753b5520921ff189974621"
  end

  resource "thread_pool" do
    url "https://github.com/rvaser/thread_pool/archive/refs/tags/4.0.0.tar.gz"
    sha256 "17120799a7fbdf88899ae6a1130aa14639f341c00c1b3dd44f54254cb56c9569"
  end

  deny_network_access!

  def install
    args = %w[
      -Dracon_build_tests=OFF
      -Dracon_build_wrapper=OFF
      -Dracon_enable_cuda=OFF
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    %w[bioparser edlib thread_pool].each do |r|
      (buildpath/"deps"/r).install resource(r)
      args << "-DFETCHCONTENT_SOURCE_DIR_#{r.upcase}=#{buildpath}/deps/#{r}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/racon --version")

    rng = Random.new(42)
    truth = Array.new(1000) { "ACGT"[rng.rand(4)] }.join
    draft = truth.dup
    draft[500] = (truth[500] == "A") ? "C" : "A"

    (testpath/"draft.fasta").write ">contig\n#{draft}\n"
    (testpath/"reads.fasta").write (1..5).map { |i| ">read#{i}\n#{truth}\n" }.join
    (testpath/"overlaps.paf").write (1..5).map { |i|
      "read#{i}\t1000\t0\t1000\t+\tcontig\t1000\t0\t1000\t999\t1000\t60\n"
    }.join

    output = shell_output("#{bin}/racon -t 1 reads.fasta overlaps.paf draft.fasta")
    assert_match(/^>contig/, output)
    assert_equal truth, output.lines.second.chomp
  end
end
