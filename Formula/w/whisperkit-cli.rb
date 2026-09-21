class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/argmax-oss-swift"
  url "https://github.com/argmaxinc/argmax-oss-swift/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9e6911887cac84ffee6193ecbcbc2ef60e4ac319a6e5689e46a4e2f944b845d2"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f46504df307e2e002b34f50d4522cfbbb2a6544908a47cb1676e4e95fd247e05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54cf5a0ae768aafe4dcbe9dad276801b67cfd5549dcde6cdf2f9435106104168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2f475013fb70c56284c8d0b4c1f3f840073e41c54f8239208fc5c4e9b600472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "55c51c1bb7d99d6ad72cdd6a6283478c38934ffd15eca7fbe2db76f8401f2114"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64
  depends_on macos: :ventura

  uses_from_macos "swift"

  # Xcode 26.3 rejects passing the non-Sendable `MLModelAsset` to `functionNames`
  patch do
    url "https://github.com/argmaxinc/argmax-oss-swift/commit/e687e26f1865e881e86be968179b13f09ec1aeea.patch?full_index=1"
    sha256 "76dedb49650016ed4196a22402d20440fc3839d3a356e246d93b1d90111ef1f2"
    type :unofficial
    resolves "https://github.com/argmaxinc/argmax-oss-swift/pull/524"
  end

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
