class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.98.tar.gz"
  sha256 "e8e09beffacd9667ed40c4652306f7e7990100164dfa26d8bd8a66b097471cb2"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b36a3c0fc29d90ec426644be41399640d6c9706d1b497f22a36b08dd8dc7fc5"
    sha256 cellar: :any,                 arm64_monterey: "686225ddaf22ba07f1fe7f3acd55452e92d38043bbd6fa38101ebf12ca9d6b8e"
    sha256 cellar: :any,                 arm64_big_sur:  "fd8e5145036602da24eb35eabca6282e905670d28fb69940a46322672f80918d"
    sha256 cellar: :any,                 ventura:        "735344bd583fe161fd5e5776d35cdd5e42a1011a2d23cc0348ec4e9c04832d51"
    sha256 cellar: :any,                 monterey:       "9b20edccc7a7ae3a3c51d3ac8d11fd7f1ff5749edcc62e6e277d3f409094f5f1"
    sha256 cellar: :any,                 big_sur:        "0d3bd5bbace4a103ff57b80d65cb678f1cb99bf670376423a31ad0335db713e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25beba2a3a3b0e376f588fd5057986eec5446340d2c29e76f076e5d33ce7c97f"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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
