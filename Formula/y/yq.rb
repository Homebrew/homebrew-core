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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2647fa4f4e870095cc3075f1949eb56fe13c6465bad94c0026f655341557f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f14ae7b2247a179d9c61dbfe031d6dbeea214382ba9e23dc3b4da2d8ddeb4267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b46cf4bb92a631ae781d705c04c16d16859f5c65dc251e82eeca01d8b8d5a67"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7410aec42a972e19aadb730447e0d5f8e0278e36d42d1288b155656769f1d63"
    sha256 cellar: :any_skip_relocation, ventura:        "b5c78848aa5b4e4e57fc65c77876905987ee4507e20028a7a62fcfe335f4a569"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc69ce9dec49778cc0e98c4bf70070796ed6aa7e5b48053ef51e310699ba93e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5cc97ff03d5d07b8f8381e7f282ef0b74b0d9c273df50535985fa0dd81cdaa1"
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
