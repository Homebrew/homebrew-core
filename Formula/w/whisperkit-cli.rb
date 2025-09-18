class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "186600da0038054635ff858aef0d72538a66ad4f1811ae389fffcba8759ea6b6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9aef473ad7bbca599878463913b0c572d8c02e3e26a4f8ff6ea633f66b0e371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ab170b6fd0d99af4435934c4ed06e07b9bd1950035f5888600908f96590b5b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3985647397b24c65464d0922e0b191c521bb3bcb76b45b1c508c913d886520f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5746ea1fe95734344e996862ff6bffcbf17d3e8da862e294ac6a69d8b6e80491"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--product", "whisperkit-cli", "--disable-sandbox"
    bin.install ".build/release/whisperkit-cli"
    generate_completions_from_executable(bin/"whisperkit-cli", "--generate-completion-script")
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
