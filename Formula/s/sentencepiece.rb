class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "92381f713e094a15a1ccff1ac4a5315a4c4b82a99ac1332d6ac53c9dc8e1bcf1"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "04cc7dbd8ea89f54dc2ba80985452abaa1aaaa1c644dbedd40c334a961f94962"
    sha256 arm64_tahoe:       "04c5953f410677d5e8deb67a42ee7953a10ed4e3d253895dc4c4b23b0abbd35f"
    sha256 arm64_sequoia:     "fa58bcba804774439f661438b539885cfdf26c6393e2bbb009599b0c07ec7352"
    sha256 arm64_linux:       "41684851ee90609e8c24579618dc3564963328a09c83ba82ccd264273f389a87"
    sha256 x86_64_linux:      "a392b4de6b2ab1edb6abced8d88214ffa32c9a35c8a8cb68c7980550b468cdfb"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSPM_PROTOBUF_PROVIDER=package",
                    "-DSPM_ABSL_PROVIDER=package",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system bin/"spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"
  end
end
