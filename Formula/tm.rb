class Tm < Formula
  desc "TriggerMesh CLI to work with knative objects"
  homepage "https://triggermesh.com"
  url "https://github.com/triggermesh/tm/archive/v1.13.0.tar.gz"
  sha256 "f05aff83e3ba52bfc3a8d54e934e0578cefae987391937e843fc4a78e41203eb"
  license "Apache-2.0"
  head "https://github.com/triggermesh/tm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53c6992c549c1806cff5bd706ffe18bfe89c2b97b2a446e29b531d329dca1a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583416efe2ce6179dc7ef2adc5a3605862efeeb71de8eb142164c933489d6bcc"
    sha256 cellar: :any_skip_relocation, monterey:       "3f87470ac28b45dd12056ae83cb0e80ee08b4af21384c7ba411b64a86c32273e"
    sha256 cellar: :any_skip_relocation, big_sur:        "34349e144e14b8151acf31b52c615e17f312502a0646d722858a3b1b851329f0"
    sha256 cellar: :any_skip_relocation, catalina:       "d644a1c8bfba10098675d0967cf43bb5dba5d0607cfe5621f2f61356f0ea1c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0320a4713bc4adf6cde486dbec454439f11d7b0047aa85f2ed61e86f6f3e27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/triggermesh/tm/cmd.version=v#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
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
