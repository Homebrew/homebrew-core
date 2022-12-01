class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.5.tar.gz"
  sha256 "54706926e44ca8f28c74c0165c4746f372daafd4db885b709fdaf5e8f2e4502c"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e088330ba9b0e0ccf81980a47938295fc2ac07ff27396f5cd86f5e27393539a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c05b30237fbf7777a5dc374b0e304b0cd82b4576b4e39c0886018a9e87d0630"
    sha256 cellar: :any_skip_relocation, ventura:        "c89c58e2c154d24f792baa856fb16b9b3b6c846737d837e44c244d24bf967f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "a30f05ab68cd8ba69c96bea2a761ff039d5fe85575c099b2e9c210e7585dbd4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cd1178ef2382b4619a472f169ba921500d262f3ee31108bb89e65d261464968"
    sha256 cellar: :any_skip_relocation, catalina:       "ae2bc1535cd1037248ffef18a2dffe0414b967eb4bb91afdd94bf97f07ff603f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e947cdfff94e5e97bdcfa83b984fc0ca5526ee9e5e6677bde549f076fdced2c"
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
