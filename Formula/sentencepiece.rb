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
    sha256 "f75c30a42e7ac2e931a8a4b19a17aa3640eef3c2e65b99fa86fb2f6af34f9131" => :big_sur
    sha256 "321f5b8fca3933b2133f97f7ebb0faa3c1384e108e1552a6f2b21f885fb1ba43" => :arm64_big_sur
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
