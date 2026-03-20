class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "01c80f436721ec8a8c3abb6710a96629f5c2a12666e6fdfde33e0bc57a74a8bf"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ca67492fbb2c7da120cb79f225049a9834ac03c752b8f8be2cdabcdfbb0a0f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b6ad99a3ecfcd00a95297a5ae9969e798ed13a892331359ecd8840b82217f93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7bdda66a181bddf5fec78e8b86f5390dc98d0083003744a39f3a61bdfe713b5"
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
