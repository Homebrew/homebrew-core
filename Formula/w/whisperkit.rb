class Whisperkit < Formula
  desc "Swift native on-device speech recognition with Whisper for Apple Silicon"
  homepage "https://github.com/argmaxinc/WhisperKit"
  url "https://github.com/argmaxinc/WhisperKit.git", tag: "v0.3.3", revision: "bfa357e897dadae0dca6314424bb119149e375d2"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on arch: :arm64

  def install
    system "swift", "build", "-c", "release", "--product", "transcribe", "--disable-sandbox"
    bin.install ".build/release/transcribe"
  end

  test do
    system "#{bin}/transcribe", "--help"
  end
end
