class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit.git",
      tag:      "v0.4.1",
      revision: "cf75348b3bd0a51cfdffbfaa7553df6a5b4e6bdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7940f346e1acaac50a94d26f5ad7925bb48dd8f75fc96e4178a608d8e09304c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e354ba10b3726f63ba17b44cbb31ec88e661aee5802be14cee340da80ae394e"
  end

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
