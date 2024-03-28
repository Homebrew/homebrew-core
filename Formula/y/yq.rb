class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.43.1.tar.gz"
  sha256 "e5581d28bae2bcdf70501dfd251233c592eb3e39a210956ee74965b784435d63"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc36b4b41929e9e689befbecb557dbf7acf6c743ca17809f65a109ef23833c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee8073f931c90c1caacc020a6b05cf7bee819ea7135890b7626601ad1787b4bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d652cf11ad65dac1d8c772168f62ca6e672ee61f69f9c47b5a46819089f1cfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f23e27ff4f8ea8a39b07ae5b7d808d5a5cbc548124b56154c0b08585737eb23"
    sha256 cellar: :any_skip_relocation, ventura:        "ccbd38a9b07256344d78bd127fb66f4d2b0f4831385d7458f5e36bed8f796548"
    sha256 cellar: :any_skip_relocation, monterey:       "85a5394913a5734cef1fc388eee37e4dfb21c69e4414c8c658b8e04cb9963262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8642969ca0738f0a4e632ee2877edf601e2747220460b29e8ab3368ff3e80a0e"
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
