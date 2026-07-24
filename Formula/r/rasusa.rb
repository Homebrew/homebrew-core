class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/5.0.1.tar.gz"
  sha256 "9d7841eafd9267a779b9966504879051ebdb56c7b11e68f1a5f550bc0064cd2c"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb7d3e0d40233239d3b069f98d8b4f58d739c44b133085f126ff8ad0a74a99ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11542c3d90884aa9af0c06af8c2a0b53e660d6b925d9c89c3e381699cab43a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a5b6a98d9638e2263470a6a505ca5b5be0848d9976a86308424ed2863b480b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c900cc1df660ef00e9aa12cdfa2bb8028065dc6a517a4aeb94ede80d3a49aa7b"
    sha256 cellar: :any,                 arm64_linux:   "9115d3a6bd66d7122c068248c11835c94a6bf2dc4a9e15024bf0d2e0a52d59e0"
    sha256 cellar: :any,                 x86_64_linux:  "1951e2a4b4ba65379af75098606b525f2075f8ab236ca32884491e366e266db2"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end
