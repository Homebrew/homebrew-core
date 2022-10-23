class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.0.0",
      revision: "6c50b2a6b1f3293918db05decacb175537834613"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e3133c5c9746895fdd64b41c6bebd21a63cf973ab9ffd15c78c92da553bc7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7c62587954a34fd55a662c39371c358b39be1d537b4e0cbe84d62c4d04d623e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92be509033e960f605e15555d67fbb8f07acb88ab9381dd195e8e905626a1f18"
    sha256 cellar: :any_skip_relocation, monterey:       "3f94a536d693adb64546e5d852858e7c523526dcf4b49fafcb083e27545c0044"
    sha256 cellar: :any_skip_relocation, big_sur:        "6047f0e498dbfb92df29c6752b735f8c48e597810987ce599961b007026ec071"
    sha256 cellar: :any_skip_relocation, catalina:       "90c036384099fda7133f1484f4aa8627ea40b9800f46d9cda5b86738b1040ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a376f72884d49ba45d064a0464aae8c8bab93f76b9f0da4901d510ae96f93d8"
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
