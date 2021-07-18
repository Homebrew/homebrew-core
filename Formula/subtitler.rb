class Subtitler < Formula
  desc "Cross-platform Java library and CLI utility for working with subtitles"
  homepage "https://github.com/caseyscarborough/subtitler"
  url "https://github.com/caseyscarborough/subtitler/releases/download/1.0.3/subtitler.zip"
  sha256 "052a3f9fc59e586ddd3bf1b532d7f7cf5d05b8c3bc7a66c6479abccdddd65daa"
  depends_on "openjdk@11"

  def install
    rm "bin/subtitler.bat"
    chmod 0755, "bin/subtitler"
    bin.install "bin/subtitler"
    (libexec/"lib").install Dir["lib/*"]

    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk@11"].opt_prefix)
  end

  test do
    assert_match "Subtitler v1.0.3", shell_output("#{bin}/subtitler -v")
  end
end
