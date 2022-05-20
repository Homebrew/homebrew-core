class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.38.0",
      revision: "89b789ddcfe00d2fe7626fd86ef39a3eb6b455c5"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f86e0f2c7df648c93973f1d1f5bb3fd36a6e70732755ba8e0275fe6a9827cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "267f1056fb46f40e4b80385b65aeced63274b4834e84ca180a18c16500026260"
    sha256 cellar: :any_skip_relocation, monterey:       "8aa5361678edd51d0186a62ce9846c0bd114bfa934dacc897d8cf5e050b232ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "86b4b0cf661910e5f405c55d5d6272a3a5bc5d5204a071e9580946ef03c089d1"
    sha256 cellar: :any_skip_relocation, catalina:       "e7f0b3a1532b269a9779de0ed47116cccc2aa62df86b6f6ecd328c3d07a8182a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30fb90ce26b77c73a6acedf99b399558d1f5a02853862209dfac2e6cb53f1982"
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
