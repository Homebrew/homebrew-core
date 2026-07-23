class Yap < Formula
  desc "On-device audio transcription using Speech.framework"
  homepage "https://github.com/finnvoor/yap"
  url "https://github.com/finnvoor/yap/archive/refs/tags/1.2.1.tar.gz"
  sha256 "0ee7ea1bd8b724acdf95575baa832365dd843caab81f9e57b33a28a5712921eb"
  license "CC0-1.0"
  head "https://github.com/finnvoor/yap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b8d6f115bdf9d2b8dbec1319cc03fd4b173408bd3014fb36be16f0ccd7194e29"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :tahoe
  uses_from_macos "swift" => [:test]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "yap"
    bin.install ".build/release/yap"
  end

  test do
    system bin/"yap", "help"

    # SpeechTranscriber not supported on virtualized macOS
    # and yap returns an "unsupportedLocale" error if run on BrewTestBot runners
    # so we only run real audio tests if SpeechTranscriber.isAvailable returns true.
    transcriber_available = Utils.popen_read(
      "swift", "-e", "import Speech; print(SpeechTranscriber.isAvailable)"
    ).strip
    run_transcriber_tests = $CHILD_STATUS.success? && transcriber_available == "true"
    return unless run_transcriber_tests

    system bin/"yap", test_fixtures("test.mp3"), "--output-file", "test.mp3.txt"
    assert_path_exists testpath/"test.mp3.txt"
    system bin/"yap", test_fixtures("test.wav"), "--output-file", "test.wav.txt"
    assert_path_exists testpath/"test.wav.txt"
  end
end
