class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "6bb4bc0111a7ba5ffdb860c5900f62796e606ec31815a15813c8c388ed5b178d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab5638391dc872230d63257f097d6175587f7296db70a2e04252debf17dfe48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52901ca7d2441a670fdaa5b2b34f3b75b62d190bef7eeee398071613a9711790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6814621ef7379644db8fc7a954bde595992515187473eea3932ee5d6db7678a"
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
