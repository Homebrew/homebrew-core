class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "5ea2a5c408c5bfc43ed3a74e867d1b44a61a2e914a8df77af95729d9c803e5dd"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2358506a946d94bda39f32d68cd6394621ec96c1260c71e33eb44a2b5cc0ecf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5ddffc38bed25c6707c59e837f247a089caa3900ca53168e01a5bd3fda9c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d38c7939b602879fc35b11d150f2a414cef47e46d6ba4f89713018d9591e91"
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
