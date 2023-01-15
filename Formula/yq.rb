class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.8.tar.gz"
  sha256 "aaf6c9f37968970413b8a6daf0b313a86efd1b8e3e5959e527b50636508eb776"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f5faf11143eb575a98639449a864aaa9c568f9b82ba29520fcd9036a1865d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f1086f9d98673f383e59fcec30fe89de60e4ee7c6c74ed901cdb0919c2cf04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1588bddb5b1c0bec6ba7127cd97304ed954686110f6cd2cba154f1f1582412d1"
    sha256 cellar: :any_skip_relocation, ventura:        "95b03d4f530b93450fe95c5bf7544c039288fa8daf2368c144db1e1343c2fecf"
    sha256 cellar: :any_skip_relocation, monterey:       "aec157746ed5f413475e1d6828335e25fd82c10304c5338981cd52312843dbe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4474c069f86b7b48d1c3db1d7ed2ed394beb95361cb46ad9dd81b55fa811922b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75c7e9544462daaea00f6f7055e3495e3335ccadf143caa49af0e7c97517594"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
