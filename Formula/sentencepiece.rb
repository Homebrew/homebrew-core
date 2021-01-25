class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.95.tar.gz"
  sha256 "99d6fc87e9a111d964dbfa85bdb0fd2eab7c469b3154db056588e974fc5b9866"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "83a099af51f446cc49000ace498502aa9044e23eef0c9439574b001a271aa3f4" => :big_sur
    sha256 "d250f1291b756967014f92acb2147c55e835b64e87d39e03332d0c2e21c48785" => :arm64_big_sur
    sha256 "e06bc08957fb608cc82029b3ca8d47fff51a00e9af625a68e46b1c84638992d3" => :catalina
    sha256 "33e69d005368a566c100f838f054d9fdc547720169da34ab39f8b773c8347e33" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system "#{bin}/spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"
  end
end
