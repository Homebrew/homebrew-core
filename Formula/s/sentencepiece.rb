class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.99.tar.gz"
  sha256 "63617eaf56c7a3857597dcd8780461f57dd21381b56a27716ef7d7e02e14ced4"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e87ca15b0001e4f83f245683724d620bad421a568eb85cdfed53db941438a4cd"
    sha256 cellar: :any,                 arm64_monterey: "37d69ef235e82f82414f1490cd60b71efc2be89850857a22ad38c4b3e72846c7"
    sha256 cellar: :any,                 arm64_big_sur:  "fa97fafd3633dbc1531169adbdbe36d9b39b13a94db6f44b9a719f14c59ba346"
    sha256 cellar: :any,                 ventura:        "15713cf96fc6eafd2c7b85748a784b9f14fbed557091427b83c35bb5d325632c"
    sha256 cellar: :any,                 monterey:       "7f88d1c72fff0ae96318ef9d00dd62ce8552b014109e3221f004ddef74db018b"
    sha256 cellar: :any,                 big_sur:        "79e0e90606d60e71c77e81d7704dae54f3cfc1fef62421dded430c326a487da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce99d2fdf1b07079488bfc65ffc164e2ee20e20a9fdb0e4acbe993716b20721"
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
