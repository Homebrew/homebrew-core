class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.94.tar.gz"
  sha256 "a23133caa67c38c3bf7f978fcea07947072783b32554a034cbbe99a8cf776192"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git"

  livecheck do
    url "https://github.com/google/sentencepiece/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "59e096e344ff58024d306ef848ca73f6ac5f3fe4afe74a73abbd3ff440c7a4e4" => :catalina
    sha256 "2c5dfda760a3c6a039a5fd83cd8c0310ff103a6abed071b91d0b8b01366c4b1b" => :mojave
    sha256 "fdfe6462b3f9fe704180831d5dc690c223075d2b2ec9505ce0a281f0bdb0187a" => :high_sierra
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
