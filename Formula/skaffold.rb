class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.1",
      revision: "cd3f6fa3231ae8abf7f028eb7163d74aafd6ae94"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  # The `strategy` code below can be removed if/when this software exceeds
  # version 2.2.3. Until then, it's used to omit an older tag that would always
  # be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v2.2.3"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7650b6cf1ad3dc03ce7c824484a84c1bae258d9d9f72ba28c6ea2dec9f0eb329"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dcb6612c9a80a420b24bbb0a1f24c26d14a58ac47917d7de0bcad029c31adee"
    sha256 cellar: :any_skip_relocation, monterey:       "8948da353af63ff993d82b6f1778c7fd7dea4cb0d671e1f98e954a92fb7b4a1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d4ada4f1ba20dc64a2262c7036deca66cdd18933637f499acd89c1dcbbc195e"
    sha256 cellar: :any_skip_relocation, catalina:       "a58c17765b6af7f29ee9fe750c314f7b4477ffb14dcf7bd38277f0de95427e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79abd805ad0b67e83d56df8f51d18b2913f63c475105f82eb0c5af9b8f529283"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
