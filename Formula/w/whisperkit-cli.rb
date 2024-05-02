class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2c23f161907bc86f032fe1b5688ab5f4c422d0a2cb11e2e4ca5e16d6668a17f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797b84a978b71cfef92120d06ab057f1da28bacc0070b3836dacfed075d3ad87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4503afe1d505dce9d4458a1b1ad7ad3f0c83f2c820a05dda24f5ba0d750b4237"
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
