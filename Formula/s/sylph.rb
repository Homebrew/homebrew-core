class Sylph < Formula
  desc "Ultrafast taxonomic profiling and genome querying for metagenomic samples"
  homepage "https://github.com/bluenote-1577/sylph"
  url "https://github.com/bluenote-1577/sylph/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c11fbe5720500c43e7102a359dd9ec59b09b93a15a8ce6f6a3bb917430c3059e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65a5db917f22490e7ccfe1c708fbea9ef4e12d58e9e204f1be4cba864dfa5a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e6499a3be2395901efaecb8b29f8afed13d73f43c15d2f85206975d971c98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96d1d8693721ee1e787c42758e4e50c30a8d63d3104e8a50709edf1ecc22ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6558b4a6efc0fffea34185b1efd5930b6465b0020467815e923f436d5813b9cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a547053071374c6de1152c674611eaacf7ba5ca3b51eba8e0e286d20d207a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5ab406da26adf6e3b73144a1bdce61fba7aeb84082691510fdb3254782d0d2"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_files"
  end

  test do
    cp_r pkgshare/"test_files/.", testpath
    system bin/"sylph", "sketch", "o157_reads.fastq.gz"
    assert_path_exists "o157_reads.fastq.gz.sylsp"
  end
end
