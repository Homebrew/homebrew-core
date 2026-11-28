class Speech < Formula
  desc "On-device speech toolkit for Apple Silicon: ASR, TTS, VAD, diarization"
  homepage "https://soniqo.audio"
  url "https://github.com/soniqo/speech-swift/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "be18d1046ffd048ad3546022a6350d6cd5696237e2e5e5470749d7b150d10978"
  license "Apache-2.0"
  head "https://github.com/soniqo/speech-swift.git", branch: "main"

  bottle do
    manifest_sha256 "5967bc6a66d5b31cd70b97f0aef525806534c89fb746d808330c31bda44fa5a6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a995af6939be012f4841a5c421e893eea168b0b2d7517415bb01151d15dc0742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ab090ed3c7969c9ebce1b9f5ad314bbfcd82b81abc2a20a52850d5a7d773f0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a311c559e0cc1ab390b0c70f3fb7dfcd2c9173d3c34cc328291b2a4d0ae71397"
  end

  depends_on xcode: ["16.3", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    # Workaround to build with newer metal until mlx-swift 0.32.x with
    # https://github.com/ml-explore/mlx-swift/commit/ab924c82ead3b970caaa1c0ac11171de23f0305a
    if OS.mac? && MacOS.version >= :golden_gate
      inreplace "Package.swift",
                '"https://github.com/ml-explore/mlx-swift", from: "0.30.0")',
                '"https://github.com/ml-explore/mlx-swift", revision: "ab924c82ead3b970caaa1c0ac11171de23f0305a")'
    end

    system "swift", "build", *std_swift_args
    system "./scripts/build_mlx_metallib.sh", "release"

    %w[speech speech-server].each do |name|
      libexec.install ".build/release/#{name}"
      bin.write_exec_script libexec/name
    end
    libexec.install ".build/release/mlx.metallib"
    libexec.install Dir[".build/release/*.bundle"]
  end

  test do
    assert_match "--model", shell_output("#{bin}/speech voice-chat --help")

    # Error path: nonexistent input triggers the audio-loading code path and
    # the binary exits non-zero with a CoreAudio error message.
    output = shell_output("#{bin}/speech transcribe /nonexistent.wav 2>&1", 1)
    assert_match "Error", output

    # Server-startup: `speech-server` binds on a port without preloading any
    # model and serves /health.
    port = free_port
    with_test_process(bin/"speech-server", "--host", "127.0.0.1", "--port", port.to_s) do
      sleep 15
      health = shell_output("curl -sf --max-time 5 http://127.0.0.1:#{port}/health")
      assert_match "ok", health
    end
  end
end
