class TrecEval < Formula
  desc "Evaluation software used in the Text Retrieval Conference"
  homepage "https://trec.nist.gov/"
  url "https://github.com/usnistgov/trec_eval/archive/refs/tags/v10.0.tar.gz"
  sha256 "3edc204c0b9b8d8fddd02c797688213dc77180ee696d14a4a66cfb32e82c1051"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7c621fd9585129cdbb8342e2580dcf9cd5149da3f7ebaf9051e923952a42a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a87e5ec7a9f6e1f74c1c8db2cd5468fa6d42721675e02d98cfc4cc88dca4bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3da26bba3c7ec988880f90dee04987ff7b205f3eebeba1bdcd3788a6ab6cca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4ee875e866ae6a31d0d3caae897074d96504711a71fd819d2b4c387d5729d7"
    sha256 cellar: :any,                 arm64_linux:   "9bb819d5d35a754579f7430886be13aee36370ec5aadac1ab7efc89801ab7c03"
    sha256 cellar: :any,                 x86_64_linux:  "821322cd215d94abd1ff88f25839f2c941d8f151191626549320e1ec5d651d5f"
  end

  def install
    system "make"
    bin.install "trec_eval"
  end

  test do
    qrels = <<~EOS
      301 0 q1 0
      302 0 q2 1
    EOS
    results = <<~EOS
      301	Q0 q1 3	1.23 testid
      302	Q0 q2 50 2.34 testid
    EOS
    out = <<~EOS
      runid                 \tall\ttestid
      num_q                 \tall\t2
      map                   \tall\t0.5000
      P_10                  \tall\t0.0500
      recall_10             \tall\t0.5000
      ndcg_cut_10           \tall\t0.5000
    EOS
    (testpath/"qrels.test").write(qrels)
    (testpath/"results.test").write(results)
    test_out = shell_output("#{bin}/trec_eval -m runid -m num_q -m\
      map -m ndcg_cut.10 -m P.10 -m recall.10 qrels.test results.test")
    assert_equal out, test_out
  end
end
