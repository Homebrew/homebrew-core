class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c1a59e9259c9653ad0ade653dadff074cd31f0a6ff2a11316f67bee4189a8f1b"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "6f944bb3a143e212d042b1e0236b6482499e34009b9b5b5db5c3cd8d9975b7df"
    sha256 arm64_sequoia: "fa43d4d4ae2951ed39dde039503b0ff519c87d17d22c3f5476e3628d320cd9a1"
    sha256 arm64_sonoma:  "090b18e649177086cfb34cd0957691ff0f9ac81763575fdc404f832e8add283a"
    sha256 arm64_ventura: "1817affe1f40c11b0780f425e0a7211e392a3ebf4aef954d3c9e84eea38a089f"
    sha256 sonoma:        "def07b0ac6928c502047e5acc59adbc31380324b1b4df2d5bce7a4b4e7e8fde1"
    sha256 ventura:       "75b11c26c25b5bc00d9ea30446ed37c46dac6caa66b941d6c2785feccecdd5aa"
    sha256 arm64_linux:   "238a7f7677d07561253da9728aa1d72c2b9f922f6fd6e2d8d0756e396f754d25"
    sha256 x86_64_linux:  "ebe9a9c2450f19edf2ac38a7d732a7c6143d9f186e5977d2b9affca6b354e84b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system bin/"spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"
  end
end
