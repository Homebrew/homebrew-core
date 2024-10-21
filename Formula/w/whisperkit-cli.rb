class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d6cc0253a32b0983fe16d8c6d5d753a86568fa4ca8ad6e90a8b93821335ceb32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4323fdce72706435de9806c30608876938d04b4dfa585d73491e1771cab0ac8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a930da3e5a9f5695bcb729e1ecc4b1db845bafb5a95b7543df63e69406f7fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c88f277cade1b8e568839c4f25e734b702d7cec80a19c1755528e910a60c067"
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
