class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.0.3",
      revision: "f5dee0f76014d4fb8df4eb89a845d5d45883ef96"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ea43e909503fbe6e5a95caca8112727cf449e42b9c8ce7fe673ed62cf9783b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b1c63ebe358b491bab8d7b5e2b04e6dd3abdf02ee14ff747a332f57e4ccaae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f4b7a79cdb0a8f95c7dcefb0721505cd08042dd67ecb1e53fe02ac77c94921"
    sha256 cellar: :any_skip_relocation, ventura:        "4d07320584b4486de2b7a9656807377c61215cd57ab1a8c7352fe8c0a1c02385"
    sha256 cellar: :any_skip_relocation, monterey:       "301f41ea3f4cbb2f737182f209fc9dc2b23d996faf9a251fcc7d7f12b46894ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "d37088d5844ebf17ef77bd69a8d4f3979e8cf52e481229c113221f87b6f23a82"
    sha256 cellar: :any_skip_relocation, catalina:       "fb6c9289cba84196cee69c7d535421bb2cf62576bc56ad21f285018b37ab15d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c8dcb0090d53a495d348ebe76b116913f37a7f1ab84c28ec80c195b348b8e8"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
