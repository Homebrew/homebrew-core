class StanfordNer < Formula
  desc "Stanford NLP Group's implementation of a Named Entity Recognizer"
  homepage "https://nlp.stanford.edu/software/CRF-NER.shtml"
  url "https://nlp.stanford.edu/software/stanford-ner-4.2.0.zip"
  sha256 "06dd9f827106359bad90049c6952137502bc59ed40b9c88b448831b32cf55b2a"
  license "GPL-2.0-or-later"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/*.sh"]
    bin.env_script_all_files libexec, JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/ner.sh", "#{libexec}/sample.txt"
  end
end
