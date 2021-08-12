class Tm < Formula
  desc "TriggerMesh CLI to work with knative objects"
  homepage "https://triggermesh.com"
  url "https://github.com/triggermesh/tm/archive/v1.8.0.tar.gz"
  sha256 "d81509a6771ecb42a39be8ca740de05ee2758e40759ad3b3ffe87b8ec60442c8"
  license "Apache-2.0"
  head "https://github.com/triggermesh/tm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c5ccef8f90c04a67b29e27584b8827709d441b04220717a66dfab0a9361e310"
    sha256 cellar: :any_skip_relocation, big_sur:       "97a35e359354f4a509ce7a050a3f9748b61c4cce6b47d02ac5bbf485e2b7cb8c"
    sha256 cellar: :any_skip_relocation, catalina:      "51889f38a8d5a166c3e26804f8c53a1279cdd406bdc82a688eacad25fd460d87"
    sha256 cellar: :any_skip_relocation, mojave:        "0ee5d6783bc66be56ae9d4f2ab1cfda7dc4c46c49904c174a7ef145841087791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e81140d7724a339041f4b0523b7b652de67fbc5f2acec70263560983fa663ed"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/triggermesh/tm/cmd.version=v#{version}
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    (testpath/"kubeconfig").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath/"kubeconfig"

    # version
    version_output = shell_output("#{bin}/tm version")
    assert_match "Triggermesh CLI, version v#{version}", version_output

    # node
    system "#{bin}/tm", "generate", "node", "foo-node"
    assert_predicate testpath/"foo-node/serverless.yaml", :exist?
    assert_predicate testpath/"foo-node/handler.js", :exist?

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/node10/runtime.yaml"
    yaml = File.read("foo-node/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml

    # python
    system "#{bin}/tm", "generate", "python", "foo-python"
    assert_predicate testpath/"foo-python/serverless.yaml", :exist?
    assert_predicate testpath/"foo-python/handler.py", :exist?

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/python37/runtime.yaml"
    yaml = File.read("foo-python/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml

    # go
    system "#{bin}/tm", "generate", "go", "foo-go"
    assert_predicate testpath/"foo-go/serverless.yaml", :exist?
    assert_predicate testpath/"foo-go/main.go", :exist?

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/go/runtime.yaml"
    yaml = File.read("foo-go/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml

    # ruby
    system "#{bin}/tm", "generate", "ruby", "foo-ruby"
    assert_predicate testpath/"foo-ruby/serverless.yaml", :exist?
    assert_predicate testpath/"foo-ruby/handler.rb", :exist?

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/ruby25/runtime.yaml"
    yaml = File.read("foo-ruby/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml
  end
end
