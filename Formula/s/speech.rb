class Speech < Formula
  desc "On-device speech toolkit for Apple Silicon: ASR, TTS, VAD, diarization"
  homepage "https://soniqo.audio"
  url "https://github.com/soniqo/speech-swift/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "4f5a6456b6456f6f94d4f18e5f504f788a3abf171c7e98ccdc4dc3ffae3837d9"
  license "Apache-2.0"
  head "https://github.com/soniqo/speech-swift.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17a244b541477a00d80804d8c6c4dff9984e385aacad6dd36dde78e4de277edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b135d9815098269fa84fe2df4063bec0c083905602e2c905899f3157dedf50"
  end

  depends_on xcode: :build
  depends_on arch: :arm64
  depends_on macos: :sonoma

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.3+

  def install
    # Sonoma's Xcode 16 clang defaults to C++98 but the LocalVQE AEC target needs C++11 or newer.
    args = ["-Xcxx", "-std=c++17"] if MacOS.version <= :sonoma

    system "swift", "build", *args, *std_swift_args
    system "./scripts/build_mlx_metallib.sh", "release"

    %w[speech speech-server].each do |name|
      libexec.install ".build/release/#{name}"
      bin.write_exec_script libexec/name
    end
    libexec.install ".build/release/mlx.metallib"
    libexec.install ".build/release/Qwen3Speech_KokoroTTS.bundle"
  end

  test do
    # Error path: nonexistent input triggers the audio-loading code path and
    # the binary exits non-zero with a CoreAudio error message.
    output = shell_output("#{bin}/speech transcribe /nonexistent.wav 2>&1", 1)
    assert_match "Error", output

    # Server-startup: `speech-server` binds on a port without preloading any
    # model and serves /health.
    port = free_port
    pid = spawn bin/"speech-server", "--host", "127.0.0.1", "--port", port.to_s

    sleep 15
    health = shell_output("curl -sf --max-time 5 http://127.0.0.1:#{port}/health")
    assert_match "ok", health
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
