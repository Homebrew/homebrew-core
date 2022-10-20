class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.97.tar.gz"
  sha256 "41c3a07f315e3ac87605460c8bb8d739955bc8e7f478caec4017ef9b7d78669b"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "6595fbab298f93719142bd70c3bac237641487025035ff6848c397272a6c5edc"
    sha256 cellar: :any,                 arm64_big_sur:  "a5b6bb58a27e411450031bc2360a7bf6c3430e3f648e974bf40f9e5234c2dc51"
    sha256 cellar: :any,                 monterey:       "74c92c3a643c7742cd7d29b5b1bd57f13a92f362108f6a63c57a27451711dfec"
    sha256 cellar: :any,                 big_sur:        "5bb87653c65a19cd69df12fc8c790bf53569be7138774705b77c34b56c291851"
    sha256 cellar: :any,                 catalina:       "8e44940c9a90d847c96f96b6a83dbdf72320c1790dd08ab9175bf9a9c5d498c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8d7bbde801110c585f23f468a347b9c5d24e1aa7f0941ee1afa62bf3a5e6ce"
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
