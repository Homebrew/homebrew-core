class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/3.0.0.tar.gz"
  sha256 "803cda395175a6806fa8b96f22f119c7e187935e9a281f6264dbdfc4d8f9068a"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43d7a5b912ba78df6c528d1a4582db135a99d25cfb0cfe4f36470fd8c9916c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "085a51b4b963fccda88cd528b39def43648d78b9e0be41c43f5b8b399ff1874c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73080124574fa3378c0bd074dcdeed324a5aec170f1ca4ec384a69d5f9cb4985"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c41daa566a8da29c719d8fbd65f6db74c376f8cc6c981b04ba8e966abe29d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "465ea183b3438673b147db9006d7f303af75b3901c1e9342b2d5746f32711a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebcc028d9d1ef17e5f1990382d4cd87552d721cae68c157e5ba0a93c886cd006"
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
