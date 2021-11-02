class Tm < Formula
  desc "TriggerMesh CLI to work with knative objects"
  homepage "https://triggermesh.com"
  url "https://github.com/triggermesh/tm/archive/v1.11.0.tar.gz"
  sha256 "edb1e7e7d86650a549d64abf435c60468a5e06ea99c4a4f66f7c25cc5c5d06cb"
  license "Apache-2.0"
  head "https://github.com/triggermesh/tm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5de538b0f06af7263b10926ecd5039fc77b20a93bb9e297ba5939e36fb15af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "361be83ad7c5f4857491077410171e033fe5a8c7c5010939b4914c5c438ccbd2"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5ab1d41c160e27f170b92c600994760fdc2a1c3323a5317c3dc3a84153fabe"
    sha256 cellar: :any_skip_relocation, big_sur:        "f35f2065ec7f38353dc92ab92e07647a88d5b19d1e2dbdbd60a933d8a36a083e"
    sha256 cellar: :any_skip_relocation, catalina:       "840f8199a03f9bf1c1f25ac1481aefa196b552967483fff8644d438e215e8de2"
    sha256 cellar: :any_skip_relocation, mojave:         "b8b5838adc3efeebc413ff34bf669db83acb2beeac8d4ede5628392c14c7c0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9835bcc2dd389f4c8c1fad3d3b9f32eb228124cf813fafcfe77ff5fc1018fcd3"
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
