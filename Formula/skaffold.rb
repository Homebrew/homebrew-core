class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.0.1",
      revision: "214fbbf644a98a1de31636e3e3a7c3d6f54e98ea"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8254f6da5eb5a397e1e1838c5fb92130ffba1ea6e04863f0286b031db7c72c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42cfaa52a2803332ab7dd53c0f64590bdf93df4a520b8117a21ea743261a4b17"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc464792bac171e90a68961074600aa54b504600359f60f6abe1f0dc0227fd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eea9bd751b285876b6aacf5579a7dabe4ed34e7ecddb7be4db88afb5c373707"
    sha256 cellar: :any_skip_relocation, catalina:       "862ed8a23ff1c97fd677e1c3159b6254f93aa1f237639ed59c0b00bbfca7b184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f66fe01bd31a589379e83cda4555fb3a056f3bba0c526a55d8b024cdfde131"
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
