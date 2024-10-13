class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.44.3.tar.gz"
  sha256 "ea950f5622480fc0ff3708c52589426a737cd4ec887a52922a74efa1be8f2fbf"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b375ddd394b7dd72206c25018e344a7fcea0888231ae47f67c7d48016f5fa8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "135b4104db54ff0f2384b484ec59d7dfa4b8d877d36b19d2c327d5dcf39ca55d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aaecc1b4c8db30398536f043f751e7410fd49d6e1f1ec3ee70562d676b9ffc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8f65e9c37da0f669deb55304aa505bdad4c34527363cf216a17aa3026ea944"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9faf2512a92295132198ec88a989ea297e8dc47283b898b3b90242301309bab"
    sha256 cellar: :any_skip_relocation, ventura:        "c43be1488640e61f0ae87902f766b3065338379838d5f924c43d24b4626f3ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "da068bc3603054ee422e89201dafc6990949d60f7b683e37d6b52c1b161b8251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2fc2e913fb1b863b3b2594318329a46676fb29c64dd5dae92711493ac3716ae"
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
