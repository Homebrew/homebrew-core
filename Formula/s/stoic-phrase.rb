class StoicPhrase < Formula
  desc "Shows a colorful Stoic quote with author in your terminal on every session"
  homepage "https://github.com/Alekla0126/Stoic-Phrase"
  url "https://github.com/Alekla0126/Stoic-Phrase/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "2f8c46bae9c52e92ddce1d9eb080a64389c46aeff4b69b1dd1801c8ed4fd9760"
  license "MIT"

  depends_on "jq"
  depends_on "lolcat"
  depends_on "toilet"
  uses_from_macos "curl"

  def install
    bin.install "stoic-phrase.sh" => "stoic-phrase"
    pkgshare.install "shell/stoic-phrase.sh" => "stoic-phrase.sh"
  end

  def caveats
    <<~EOS
      On first run, stoic-phrase will ask for your name and save it.
      To show a Stoic quote every time a terminal opens, run:

        stoic-phrase --enable-startup
    EOS
  end

  test do
    ENV["STOIC_PHRASE_USERNAME"] = "brew"
    ENV["STOIC_PHRASE_QUOTE"]    = "Discipline is freedom."
    ENV["STOIC_PHRASE_AUTHOR"]   = "Epictetus"
    ENV["STOIC_PHRASE_NO_COLOR"] = "1"

    output = shell_output(bin/"stoic-phrase")
    assert_match "Discipline is freedom.", output
    assert_match "Epictetus", output
  end
end
