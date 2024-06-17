class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.44.2.tar.gz"
  sha256 "eb741c2d41351537aa42d563d0fccf16b3195c352b33e0ef111fd448232da911"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "977679430d5dafca5fcb26f8c0f085ca4d6b0378a8ba6e948a4bf77ac210093d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "398c8ab340dbff5808bbd4b03b9abe6c6c2898577cd1a01d276bee8750749519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308f642333ed2b98edc08cd9949a4be30b68077e4a094cc44388f1a5c42e5e5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e5ef90594c34eaff5beb3474d28a12dc593f63695518b2e762ef837323a6ffa"
    sha256 cellar: :any_skip_relocation, ventura:        "1ffca458716ecbce38c8c66758af3dc3b2e365299305ba5c5ce9e5fa604ffd61"
    sha256 cellar: :any_skip_relocation, monterey:       "03059d9e8e1fd024e4dd27d72e82b2f5b38fae67a0d0c0e72d8fd79ac68a337c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a1e8274841cb3122204e9e637bcf81b393de0efd8cc17a3201dea362a29808"
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
