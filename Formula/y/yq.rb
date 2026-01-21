class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.50.1.tar.gz"
  sha256 "ec55f107fbfe1d8226c1d4d74def734672f9aa58165029819ddfb771339e53a1"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f7ae016708d84e1f5a5033affe7aa2682c1ac86c3e0b705494fcf2b117f0da3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7ae016708d84e1f5a5033affe7aa2682c1ac86c3e0b705494fcf2b117f0da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7ae016708d84e1f5a5033affe7aa2682c1ac86c3e0b705494fcf2b117f0da3"
    sha256 cellar: :any_skip_relocation, sonoma:        "78c1b4d3c399ca3a901837181b89cd900177e5461b3ed39ed36fae5af45bc441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "368c356c2a72688627a215e6f0eeee28b436918287eab74c7f81b2ceeb843a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f7cd9bfd97992c037ac97acc79c2c60e0d21e9eac71d058d3cca74efdbcc58"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    assert_equal "cat", pipe_output("#{bin}/yq eval .key -", "key: cat", 0).chomp
  end
end
