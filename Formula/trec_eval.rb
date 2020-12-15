class TrecEval < Formula
  desc "Evaluation software used in the Text Retrieval Conference"
  homepage "https://trec.nist.gov/"
  url "https://github.com/usnistgov/trec_eval/archive/v9.0.8.tar.gz"
  sha256 "c3994a73103ec842e12df693749584a45814c35c36dcc15f38984bd463566ba1"
  license :public_domain

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
    test_out = shell_output("trec_eval -m runid -m num_q -m\
      map -m ndcg_cut.10 -m P.10 -m recall.10 qrels.test results.test")
    assert_equal out, test_out
  end
end
