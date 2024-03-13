class Whisperkit < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit.git",
      tag:      "v0.3.3",
      revision: "bfa357e897dadae0dca6314424bb119149e375d2"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on "git-lfs"
  depends_on :macos
  depends_on macos: :ventura

  def install
    system "swift", "build", "-c", "release", "--product", "transcribe", "--disable-sandbox"
    bin.install ".build/release/transcribe"
  end

  test do
    mkdir_p "#{testpath}/Models/whisperkit-coreml"
    ENV["GIT_LFS_SKIP_SMUDGE"] = "1"
    system "git", "lfs", "install"
    system "git",
        "clone",
        "https://huggingface.co/argmaxinc/whisperkit-coreml",
        "#{testpath}/Models/whisperkit-coreml"
    chdir "#{testpath}/Models/whisperkit-coreml" do
      system "git", "lfs", "pull", "--include=openai_whisper-tiny/*"
    end
    system "#{bin}/transcribe",
        "--model-path",
        "#{testpath}/Models/whisperkit-coreml/openai_whisper-tiny",
        "--audio-path",
        test_fixtures("test.mp3"),
        "--audio-encoder-compute-units",
        "cpuOnly",
        "--text-decoder-compute-units",
        "cpuOnly",
        "--verbose"
  end
end
