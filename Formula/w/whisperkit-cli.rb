class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "186600da0038054635ff858aef0d72538a66ad4f1811ae389fffcba8759ea6b6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6d84f71a1807e18bf8067db1070ed275d13072f769dc45ec694392e6555097e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06dfa1bde283b12e6d195a3f5d3baf54d212d852e2b449f014cff078421da841"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2a03c038e735dd44d5628682afe379f72145bd8cf76a85adf69a1e7b5a87ca4"
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
