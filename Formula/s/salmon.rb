class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "aa5340ac7279a9d3d38a498adbf239b61f07c957236b3008712f1e17e8fa4b31"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc40f1f075b9fdcfe18a90ad6b2e9a61fd1893ff2461ebd8c88bc2ee432914e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0cf425e39a06df73e4a1b33908e042c919b73baadf4cb77ccba4975cdb2e5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "367cf7a7a33dfcaf9a3bac34525c47945cde618f5ea0c3f6d3263039b3e0e6b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "251b61f2536d2640202ddf85226b6912fbb1b10151d3eb5bcf09ca6861b91154"
    sha256 cellar: :any,                 arm64_linux:   "e45a71ddc888db92f0926721d78c472b53ee1172262a47be60e4e01136faba65"
    sha256 cellar: :any,                 x86_64_linux:  "63f5c4b00528ccb87742143b124dfbf6da0f741887a75880f90ff10fd695e84e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/salmon-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version")

    (testpath/"txome.fa").write ">t0\n#{"ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT" * 4}\n"
    system bin/"salmon", "index", "-t", "txome.fa", "-i", "idx", "-k", "31"
    assert_predicate testpath/"idx", :directory?
  end
end
