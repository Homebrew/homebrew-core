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
    sha256 "34eaf54eed2f033c154575c04b517742dea72d9fdba2d80515348acb9afb8793" => :catalina
    sha256 "367c727302ab46993a8604b21f4276d051bb06e17dd91b27252639abee05d84b" => :mojave
    sha256 "81a320ad4d6d5c92493f471735bc50fc38ca580d97dd4c710928e743f48d3841" => :high_sierra
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
