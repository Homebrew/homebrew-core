class StanfordNer < Formula
  desc "Stanford NLP Group's implementation of a Named Entity Recognizer"
  homepage "https://nlp.stanford.edu/software/CRF-NER.shtml"
  url "https://nlp.stanford.edu/software/stanford-ner-2018-10-16.zip"
  version "3.9.2"
  sha256 "fa737bc6d7ac01de6d13a4628b229b7eabae24c446bc616608b7aad04ed6c65a"

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
