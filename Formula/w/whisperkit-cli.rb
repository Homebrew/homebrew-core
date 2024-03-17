class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit.git",
      tag:      "v0.4.0",
      revision: "59cb8516c708e3e2f18198002600026b5a1135ca"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura
  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--product", "whisperkit-cli", "--disable-sandbox"
    bin.install ".build/release/whisperkit-cli"
  end

  test do
    mkdir_p "#{testpath}/tokenizer"
    mkdir_p "#{testpath}/model"
    whisperkit_command = [
      "#{bin}/whisperkit-cli",
      "transcribe",
      "--model",
      "tiny",
      "--download-model-path",
      "#{testpath}/model",
      "--download-tokenizer-path",
      "#{testpath}/tokenizer",
      "--audio-path",
      test_fixtures("test.mp3"),
      "--verbose",
    ].join(" ")
    assert_includes shell_output(whisperkit_command), "Transcription:"
  end
end
