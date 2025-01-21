class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "ad6375e1b3ac6e1dd4d0c7d71e163f6004474edceb201298602a4792bb690140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b287abc2bdaba74c7a36031e104673c675c6c33062c0bd46257be24654ab2a51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "303c6b3a9d7ba8886db148f9debba6415bf8febc742fdaf2ac7b1bcbdac75a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcaae97c302ccf2915287e9145cd8a837310e25c1dd276ac860dbdb7f3859cec"
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

    test_file = test_fixtures("test.mp3")
    output = shell_output("#{bin}/whisperkit-cli transcribe --model tiny --download-model-path #{testpath}/model " \
                          "--download-tokenizer-path #{testpath}/tokenizer --audio-path #{test_file} --verbose")
    assert_match "Transcription of test.mp3", output
  end
end
