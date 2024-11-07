class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "5815b7659870908d85088434ce63be73bb4d7d484752062617708d91b8cdee26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee6bca812f3ed23da7427ec156357e533ab1d300baf04e133bc47f53f9e6267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be47cb24152d3e99e7be5f285e836b736f8d1642c5de553b15e3627d114f0b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78f1b703839bc75d414e9e4722db3d391073d9b4bf4b53ff69dd670a224d4355"
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
