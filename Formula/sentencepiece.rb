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
    sha256 cellar: :any,                 arm64_monterey: "33e3ced6cdf475a8bbe92ba4ac977d119647c3806dc8b4cff9b6ce1219da1a0d"
    sha256 cellar: :any,                 arm64_big_sur:  "74690268165e2dc16bf6d1d45767c733b82c7c7575184b55a818e0c6d4c72445"
    sha256 cellar: :any,                 monterey:       "546e9a7708d2e407d0a8e6ac1c80dbf398d3f6ef9de4953916a61925c6b7dd68"
    sha256 cellar: :any,                 big_sur:        "b0837ad9b7e0740cc76fc9d0652b49aa4dd35c2337dc9a7c8fa035702e297417"
    sha256 cellar: :any,                 catalina:       "0caffd7e57ad71af08677d661ac7c0917da0f0d93c1db36dcbb3d052073fb989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab2543965444ecdee1edc84d6fd74096303c10b924307d1d752388a3547d9ba"
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
