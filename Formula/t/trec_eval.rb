class TrecEval < Formula
  desc "Evaluation software used in the Text Retrieval Conference"
  homepage "https://trec.nist.gov/"
  url "https://github.com/usnistgov/trec_eval/archive/refs/tags/v9.0.8.tar.gz"
  sha256 "c3994a73103ec842e12df693749584a45814c35c36dcc15f38984bd463566ba1"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "76b82a760b649ff274423803886addc93b50219638567a293aa3cfbb996da7bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fcdd6e403afdb47f056383b66c17ec205973b463c9f09e0991b5272eacddfaa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55f874cf4900def882e6d43572bb1da136c2b2fc4a457bdd0fee5a02e865b197"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16c8aaa0d9b33883411eba081aee36c8dda1bc3e2ed8ea84e9883c9edf320e9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01082fb524981b3e81e180e9a4a1ac92e0fe68ef210318e0a1c41eadad89a291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "908cb93ceda4eb3561890ed39752d7ea5e2f41e5aced235445426bcc52958080"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d65df57d397752e4cd42b01eb7eb4a0160e08e357215a3ebbecacdb9baa1647"
    sha256 cellar: :any_skip_relocation, ventura:        "c3bc70311ebbcabf059835dcd53f3eb1fe056dfc01f517bad1e1f0c9f4cb6ec9"
    sha256 cellar: :any_skip_relocation, monterey:       "0d8a6a62eb6ff6687da3c825bbc4f9b655b1435012f12fbadab8d7c00bcc7cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "909a8fa72d9da9dc50790dd31faf7ce80bfa13f6714fb39008ea4ef9ceefbff5"
    sha256 cellar: :any_skip_relocation, catalina:       "ea8723ce3d27bc893ec5255f8bb3235d03d442a58ef36586997b085626d752c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cfa28a32fa647c2cd07ae80866f5962a1cd62a464e4e372d1d305920687b04f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3ec132aca6dc41b193e739765cbc951b20c705d84aac1a98f930a5ebb1ee32"
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
