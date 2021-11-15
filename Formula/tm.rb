class Tm < Formula
  desc "TriggerMesh CLI to work with knative objects"
  homepage "https://triggermesh.com"
  url "https://github.com/triggermesh/tm/archive/v1.11.0.tar.gz"
  sha256 "edb1e7e7d86650a549d64abf435c60468a5e06ea99c4a4f66f7c25cc5c5d06cb"
  license "Apache-2.0"
  head "https://github.com/triggermesh/tm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f068e3ff4f31d0e0eb48021d9a7880f3072b409dab1c6705bba0654d7aa0a1f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91849b4ac672df1bc3029e0e430790e753b703485b72372ec312fe66f8200c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "36b6ab8c2117dae71a935545a209288f74d24c3457e51814320f29245e1f51be"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef6ed69cf2940d564a2276426b6c404a4df9961bf694c35db5fa685060e63a50"
    sha256 cellar: :any_skip_relocation, catalina:       "29f11fd2c1825fc0d4572a541292da44d0f619b6892f4b3979d6b3b9c5aba647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13436b51d87221b2763b63635273a72b373d08544069d978eb384ed644934b46"
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
