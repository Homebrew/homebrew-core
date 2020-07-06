class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.92.tar.gz"
  sha256 "6e9863851e6277862083518cc9f96211f334215d596fc8c65e074d564baeef0c"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git"

  bottle do
    sha256 "c169b40d2a856514440b4fdfa7f461b9f1b2bc8c7d5e6603c3e42e8e62f90c0f" => :catalina
    sha256 "c144cb6375e447c1aee9616ab22250830892aa7bfdf230b3edc0c0a41a0bfa96" => :mojave
    sha256 "eb919fd4dc87993b2f4b6f8a58683831a7c2fb0f3abbcdf4a320f8bf761cdb8e" => :high_sierra
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
