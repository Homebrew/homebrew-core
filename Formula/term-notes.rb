class TermNotes < Formula
  desc "Terminal-based note-taking application"
  homepage "https://github.com/felipealfonsog/TermNotes"
  url "https://github.com/felipealfonsog/TermNotes/archive/refs/tags/v.1.0.2.tar.gz"
  sha256 "e1ae65286b64c3466d5749524c79df1063ec9db35b265f0359d24cc76397d88c"
  license "MIT"

  depends_on "gcc"

  def install
    system "gcc", "src/term_notes.c", "-o", "term-notes"
    bin.install "term-notes"
  end

  def caveats
    <<~EOS
      'Term Notes' has been installed!

      On macOS, you can run the program using 'term-notes'.

      On Linux, you may need to create a symbolic link to make it accessible globally.
      Run the following command:

        sudo ln -s #{opt_bin}/term-notes /usr/local/bin/term-notes

      Enjoy taking notes with 'Term Notes'!
    EOS
  end
end
