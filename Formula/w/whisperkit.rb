class Whisperkit < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit.git",
      tag:      "v0.3.3",
      revision: "bfa357e897dadae0dca6314424bb119149e375d2"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on "huggingface-cli"
  depends_on :macos
  depends_on macos: :ventura

  def install
    system "swift", "build", "-c", "release", "--product", "transcribe", "--disable-sandbox"
    bin.install ".build/release/transcribe"
  end

  test do
    require "json"
    mkdir_p "#{testpath}/Models/whisperkit-coreml"
    system "huggingface-cli",
        "download",
        "argmaxinc/whisperkit-coreml",
        "--include",
        "openai_whisper-tiny/*",
        "--local-dir",
        "#{testpath}/Models/whisperkit-coreml"

    file = File.read("#{testpath}/Models/whisperkit-coreml/openai_whisper-tiny/config.json")
    config_hash = JSON.parse(file)
    config_hash.delete("_name_or_path")
    File.write("#{testpath}/Models/whisperkit-coreml/openai_whisper-tiny/config.json", JSON.dump(config_hash))

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
