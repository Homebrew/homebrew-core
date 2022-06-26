class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.96.tar.gz"
  sha256 "5198f31c3bb25e685e9e68355a3bf67a1db23c9e8bdccc33dc015f496a44df7a"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e85c278ec13e1d4256688b85da4229ddbfc59b59399ecaea922b2144deebea39"
    sha256 cellar: :any,                 arm64_big_sur:  "f7f3e11b9915fb85ac7af279eb89461781f1cb9ef849a3af6680b49b4a0a1f4e"
    sha256 cellar: :any,                 monterey:       "a5b5b6178824b9dc7bdf5121fb9bd7c77865127383fb1003ba73566a92c9f5b7"
    sha256 cellar: :any,                 big_sur:        "eea4ce35e1bcfa7b5d82ba21071128f7afaa528aec2ebacff98fdc18afb7dde2"
    sha256 cellar: :any,                 catalina:       "2d6622948cbaf6f114b6bcacf179ff072ce647054161e081a04013b27cf547b4"
    sha256 cellar: :any,                 mojave:         "aabe9c776c900c63034f423c7c5d9983ff4cd0156199e2b9153f77a4f2961929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ffd466ae7212086b72c7863ff018555170d945c5aadcfe6a67e8cca7f9ca65b"
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
