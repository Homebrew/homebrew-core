class WhisperkitCli < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/argmax-oss-swift"
  url "https://github.com/argmaxinc/argmax-oss-swift/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f81c46732d2a2b6886d0372032fba059e565c640d3c8b7177badee4691fdc5bb"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b386964fdcdd778c00afc62a747e2a639724b372895498a6fee73d57330bd15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6bc04656e3941084f5b58b007db3f7a582483a6905433dba55d07350c2b43a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03beac1ba3b6d13c4d821358f7d7ad1e84ebb06dd0c93beac4e04daf0494716a"
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
