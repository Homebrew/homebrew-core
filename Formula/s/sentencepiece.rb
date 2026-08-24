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
    sha256 arm64_tahoe:   "7d406f5c4038297a6c4e74d29c787d2e61c4a4e9a3731d932a16ececd3907063"
    sha256 arm64_sequoia: "bcc1478961f02808a8e6c4aafbba13e45d278a2c6d14c989af893d9bd4667089"
    sha256 arm64_sonoma:  "b410a67e14a12781d70067321da4428986fa79984fb9bae0cda527ee5e7031b7"
    sha256 sonoma:        "a805c767d5434b055f66b997f3cfe0aac2e65d69c852023c42eb8f31e758eb8e"
    sha256 arm64_linux:   "4b1555d09f19e8d0e1511e698f8e91bb085087d0f72b83b6d10ce1d924c6015c"
    sha256 x86_64_linux:  "e312e1b6fed7ba3c61e922db05bd647b50084c46052f118a3a4d42f7acd041af"
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
