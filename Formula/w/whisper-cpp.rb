class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "06eed84de310fdf5408527e41e863ac3b80b8603576ba0521177464b1b341a3a"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1214a35555c1e42894ccb74fa8aee5b8adf9492de5c7a869aafe25a526c3fc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1f235046a5792cfcd4e8e3abc4014ba1c6000e2c426d64d2553133b73242613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca9e9126e73f160ee4ca188464d20b5ef86275271d3060b05f5db6e7a571daba"
    sha256 cellar: :any_skip_relocation, sonoma:         "50ba397b8f35223c1022c56bab606a3df1e893cebf32022bc845cf1ab9c99e92"
    sha256 cellar: :any_skip_relocation, ventura:        "1d7ffc4a9c9add0919a69b16141d41495a98a9538053ea73cf08655a63e0f32f"
    sha256 cellar: :any_skip_relocation, monterey:       "90f4d20efb428c9ca021eb7db8abd432640ca2fb68a5578b84154f53d337fbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7187c90ab975f4558c1762a608e09bd16f897690b55308aa27bb6d21e86c2e2"
  end

  def install
    system "make"
    bin.install "main" => "whisper-cpp"

    pkgshare.install ["samples/jfk.wav", "models/for-tests-ggml-tiny.bin", "ggml-metal.metal"]
  end

  def caveats
    <<~EOS
      whisper-cpp requires GGML model files to work. These are not downloaded by default.
      To obtain model files (.bin), visit one of these locations:

        https://huggingface.co/ggerganov/whisper.cpp/tree/main
        https://ggml.ggerganov.com/
    EOS
  end

  test do
    cp [pkgshare/"jfk.wav", pkgshare/"for-tests-ggml-tiny.bin", pkgshare/"ggml-metal.metal"], testpath

    system "#{bin}/whisper-cpp", "samples", "-m", "for-tests-ggml-tiny.bin"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end
