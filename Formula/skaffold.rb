class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.3",
      revision: "81e44af02f368afe411e29d095a9ed5494018e66"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "048533c014f8b32f8d21b1fdd434af91cc6da9947e1d8d2cd0c931f1d46f09af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8733c819c580629d698c9f8d540650d5e22e8dd4c049805e49b317963ad402b7"
    sha256 cellar: :any_skip_relocation, monterey:       "6e93973a403eb888733d67431a632917a4279a54bfbdfb09a45bfa079842e9c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7653581f4f7fe50030ffcd08ddfaff89d502222928682f28384838f165ffddac"
    sha256 cellar: :any_skip_relocation, catalina:       "b15f29311b89c039bff46513800fec0910be74f2e62e7f7432e92caedc38b159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230f780699881cc6b8cf5d04d0c9a76f1ed84c85fc3b3ba23c272cc2ecee6c74"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
