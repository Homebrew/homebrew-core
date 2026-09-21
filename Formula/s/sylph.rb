class Sylph < Formula
  desc "Ultrafast taxonomic profiling and genome querying for metagenomic samples"
  homepage "https://github.com/bluenote-1577/sylph"
  url "https://github.com/bluenote-1577/sylph/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "dd4ba47906be7f3502b6bec88fa212ba5340b1eefced0192052ef0da82ca3a2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce1cc43a16a406426cde777ee7abfde0553d6c5c8a6461d9bf0bd55b6e6dedc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e016ca805181652ca6d8eb424163bb2f5ef69615353c4684cf4ed3040672b07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75192d460f8261a3e40c5343827037c0774704f7020ce2ecc954ecb4419d968b"
    sha256 cellar: :any,                 arm64_linux:       "ca22476a188aa5c44dfbdb757e2f285a2c20c36ee748cb58d332208ca390d54c"
    sha256 cellar: :any,                 x86_64_linux:      "9c34a2aa31a97052880507dc2590d76447cd96a3fa1f64f51680ce085c049057"
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
