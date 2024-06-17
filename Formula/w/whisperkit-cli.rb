class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "6c0261c1935b8567c4a6f872d8b2c4c036b088526d90f552e8db0b53aff395e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0b9de790e95d44427e887774cd9d272efe1cc045b3172357ce9b42f2b1aa56d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae78403d6edc48d622028d300bc643f9b09cdee7b3c8b22cdafe0271187b02ae"
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
