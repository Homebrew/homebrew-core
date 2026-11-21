class Yap < Formula
  desc "On-device audio transcription using Speech.framework"
  homepage "https://github.com/finnvoor/yap"
  url "https://github.com/finnvoor/yap/archive/refs/tags/1.2.2.tar.gz"
  sha256 "a078bb4908cea4e0eb22953e4acf85b137d6d69218deed652658e21fac905793"
  license "CC0-1.0"
  head "https://github.com/finnvoor/yap.git", branch: "main"

  bottle do
    manifest_sha256 "70e00c715a0956eea99286cd30324c6d63af0e6354d9dd340eb6439aca6bfb22"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2d736e0613c4718c96505c8d37f5bfcb31f1134499f49156242c984d8499a4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f53a363b4e7c0ac5de8c5b3175d743e137d05dbba52bff99104804e37c505ce0"
  end

  depends_on macos: :tahoe
  uses_from_macos "swift" => [:build, :test]

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", "--product", "yap", *std_swift_args
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
