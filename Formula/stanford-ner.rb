class StanfordNer < Formula
  desc "Stanford NLP Group's implementation of a Named Entity Recognizer"
  homepage "https://nlp.stanford.edu/software/CRF-NER.shtml"
  url "https://nlp.stanford.edu/software/stanford-ner-2018-02-27.zip"
  version "3.9.1"
  sha256 "e37b0094040c95e98799d849a7be2f4967de6b786f0b07360d179756bd4dce95"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    system "#{bin}/ner.sh", "#{libexec}/sample.txt"
  end
end
