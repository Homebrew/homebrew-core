class TrecEval < Formula
  desc "Evaluation software used in the Text Retrieval Conference"
  homepage "https://trec.nist.gov/"
  url "https://github.com/usnistgov/trec_eval/archive/v9.0.8.tar.gz"
  sha256 "c3994a73103ec842e12df693749584a45814c35c36dcc15f38984bd463566ba1"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01082fb524981b3e81e180e9a4a1ac92e0fe68ef210318e0a1c41eadad89a291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "908cb93ceda4eb3561890ed39752d7ea5e2f41e5aced235445426bcc52958080"
    sha256 cellar: :any_skip_relocation, monterey:       "0d8a6a62eb6ff6687da3c825bbc4f9b655b1435012f12fbadab8d7c00bcc7cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "909a8fa72d9da9dc50790dd31faf7ce80bfa13f6714fb39008ea4ef9ceefbff5"
    sha256 cellar: :any_skip_relocation, catalina:       "ea8723ce3d27bc893ec5255f8bb3235d03d442a58ef36586997b085626d752c7"
    sha256 cellar: :any_skip_relocation, mojave:         "cecbd8490c8b889b72922ff9d6f6fdd5bed740e211217b4ac5c37b742b4e1b41"
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
    test_out = shell_output("trec_eval -m runid -m num_q -m\
      map -m ndcg_cut.10 -m P.10 -m recall.10 qrels.test results.test")
    assert_equal out, test_out
  end
end
