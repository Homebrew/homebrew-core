class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "4fa4b537b1b142913c9ae44a2bfde50b423b292dca5cc203d16dc84456f18b8e"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ed2738112beebb7313489f9e5c3ae46ed0af63b2fa7000ed369feb8cbe5673e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32165e285968ce46936ba2a07a0c1937baeab777cc2113d432cbf58f31ddb547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcf8735e85b99f26299711e0f8f27cb6d7fd1b2b8ae9c6ba5ac0473d5eb26cba"
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
