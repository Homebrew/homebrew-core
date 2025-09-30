class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "191db947fb7219ef4e68188d8ab58a32cd0da7542badedc480089afa37f14ecf"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "982007b3ea8e82d10d921b22f42e6194cfa522d436fe7a88bebe90a79c1f1392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d2b956d492974b9dfbd27ee87c379af486b0e66d9a94df24420d7f46385c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2041adae5c4abf8a4e52c9870fae60b06500cd279001866ac5b6dd1a753a33"
  end

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on macos: :ventura

  uses_from_macos "swift"

  def install
    ENV["BUILD_ALL"] = "1"
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
