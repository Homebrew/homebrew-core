class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.91.tar.gz"
  sha256 "acbc7ea12713cd2a8d64892f8d2033c7fd2bb4faecab39452496120ace9a4b1b"
  head "https://github.com/google/sentencepiece.git"

  bottle do
    sha256 "d65c679bb760be25ab088947503541a62d4fe3bf73d182bc618702fc29463d45" => :catalina
    sha256 "64278463f601a298edca2d3c334b8b4e9afefcc6cb3c6d31bf37b09f38f709fe" => :mojave
    sha256 "a935105f263603af33cb30190e3a324758914b72e82dae1ab31908ee0848aaef" => :high_sierra
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
