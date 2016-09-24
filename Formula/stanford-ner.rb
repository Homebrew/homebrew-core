class StanfordNer < Formula
  desc "Stanford NLP Group's implementation of a Named Entity Recognizer."
  homepage "http://nlp.stanford.edu/software/CRF-NER.shtml"
  url "http://nlp.stanford.edu/software/stanford-ner-2015-04-20.zip"
  version "3.5.2"
  sha256 "cd33ace6e9f92530024d9e04faf3c33c6d7db9841e8d8b85e257faeadfb25cff"

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
