class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/argmax-oss-swift"
  url "https://github.com/argmaxinc/argmax-oss-swift/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "65a0dc984802026d03382a32af234ba0cdde3b49de5a19f4df711bc9fee9f0fe"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9671ccd6ad3cfbd39a55c3a8c2c364672c94902fc20a6eca102de0c76b08f7f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98d932596bf479fac27ff32936432eaf9ce30bd7eedf2190ed740beb2d69f334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddd45bb672a553bf23f713fe135bf8d6c1c303de2f7a0bb220c420674e734fab"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on macos: :ventura

  uses_from_macos "swift"

  # Test downloads a Whisper model from Hugging Face
  allow_network_access! :test

  def fetch
    # BUILD_ALL enables additional dependencies in Package.swift and must
    # match `install`. SwiftPM tries to apply its own sandbox, which cannot
    # nest inside the build sandbox; Homebrew's sandbox still confines the
    # whole process.
    ENV["BUILD_ALL"] = "1"
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    ENV["BUILD_ALL"] = "1"
    system "swift", "build", "--product", "whisperkit-cli", *std_swift_args
    bin.install ".build/release/whisperkit-cli"
    generate_completions_from_executable(bin/"whisperkit-cli", "--generate-completion-script")
  end

  test do
    mkdir_p "#{testpath}/tokenizer"
    mkdir_p "#{testpath}/model"
    test_file = test_fixtures("test.mp3")

    # Will crash in sandbox so using pipe_output to ignore exit codes and only checking initialization
    output = pipe_output("#{bin}/whisperkit-cli transcribe --model tiny --download-model-path #{testpath}/model " \
                         "--download-tokenizer-path #{testpath}/tokenizer --audio-path #{test_file} --verbose")
    assert_match "Model initialization complete", output
  end
end
