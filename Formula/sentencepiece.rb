class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.84.tar.gz"
  sha256 "7f5505bd46aa5103ad235d61c269932c5922e68597eb484a9d27faed6af1419f"

  bottle do
    sha256 "e30acde8207449bdb9e9ae91725fc70b84cfea35311058fab27040db88e0017b" => :catalina
    sha256 "7d8a60234fff512aaae93d55457f11296a82a3181151ef41396340124fb33ed4" => :mojave
    sha256 "ef3666709a067d7ad6e544ee8d03f6fac625e39a6ab2fb23818af516079aaf8b" => :high_sierra
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
