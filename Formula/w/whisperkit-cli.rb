class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a1f138bea9899e838c400fa1576c1eb2ee4bbfa7d59280b3a6b63237550003fa"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471ea55675a104ff877f7708154f5ae51bd63c844b3227e102a7bb41c9bf5707"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e91685c545151ea8d24e083b44327cd12071a57f38acf6f528bffcec0a8af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35867a01171698722d2085fdaf6afa8ae841e0b0b13a171b2b23f575e86bc626"
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
