class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9970f0a0afee1648890293321665e5b2efa04eaec9f1671fcf8048f456f5bb86"
  license "Apache-2.0"
  head "https://github.com/google/sentencepiece.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5865d6a86cf12fb46ad1c78801df76607ff5f06e85688f5a2f50eb62ab229065"
    sha256 cellar: :any,                 arm64_sonoma:   "be81111eedcf3e3052c9a5732545334e05e639266e65da1de411b4f9ae2ec087"
    sha256 cellar: :any,                 arm64_ventura:  "c01378960b8a4033dd3d46e91cd4d539efc0338a13e275c4c1e0e2a93cc5259d"
    sha256 cellar: :any,                 arm64_monterey: "05052dcf7866538c81635dc87207357c0e76a01da049495877c876b6daa21851"
    sha256 cellar: :any,                 sonoma:         "5d089f589a58149a63856bda2f1f02374126c5790b07bc7af3eaa90ab70010f1"
    sha256 cellar: :any,                 ventura:        "79142fc5301e99ad6b9d21fc58a7a16b2b7761a97671e702695a2d284b65d6d9"
    sha256 cellar: :any,                 monterey:       "d1a724c96a74d152a278293a5d3b1d16c0b0f509fa439911c6388400897fb89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a0c0c1c6be1bdc0df16dc56facca66fe989d5ede7a5728ea05577387beb368"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system bin/"spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"
  end
end
