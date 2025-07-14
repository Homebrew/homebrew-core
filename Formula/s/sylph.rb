class Sylph < Formula
  desc "Ultrafast taxonomic profiling and genome querying for metagenomic samples"
  homepage "https://github.com/bluenote-1577/sylph"
  url "https://github.com/bluenote-1577/sylph/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "9dceb4e2302ece3ca225218dfb8367c88a88c98d1eb4e8eac82a202195584099"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2954424cd08c4d8072a175ebc40f37ecf77b0d06e951260f25b05b34567f4c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c93babdea5665924b5cb74d60f02a7d42bdbfd12cb9dfbb8eda92c33c8dbe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d50d6ad5c25502e1d71a0a181cc620904ae158527033a9161a9da8c4565ba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5070cc49e003cb41107c381f915f10edeabb2dbf96fe44fec23801d0e5646104"
    sha256 cellar: :any_skip_relocation, ventura:       "eae42b22d269a0b84c5f5563f287c27162ec28a7cd0f5bc64e9f5d02d447de4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46bf1127605e65216e0a72b8002756a99d5c92b29b90561c41e9428ff48127dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c3f96393a71348348ca80657d9cb13de8acd19744b8744f138a8d42c774b7d"
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
