class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.35.2.tar.gz"
  sha256 "8b17d710c56f764e9beff06d7a7b1c77d87c4ba4219ce4ce67e7ee29670f4f13"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00c7ddd0a55c4e568adcd132e8d7237323a2d4420f2dcb5ca181fee09799fe5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c250de25ccdef46918ca4a0e741afd07264098e441e85961f19876d4cb44619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "529fc766b8f90e38c567d3ffdc7d98a5de2d07dd3927f11ca4bf2432e83c8fd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b78ebfef3a66fcc146e081c69058f5962e6c006dc233a655376221814c5050f2"
    sha256 cellar: :any_skip_relocation, ventura:        "ac7b8dbe3ec2846631185ed1939acc236df88305eab4cab768ea104caba146cc"
    sha256 cellar: :any_skip_relocation, monterey:       "3eb5dc0fcf9059d25a50984b08b5fcd484ed976972a59984dc10405560f96442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fb3392745bd82d694bb0539c603dcc759ffa64387ba33f41c925484f9756a74"
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
