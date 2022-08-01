class Tm < Formula
  desc "TriggerMesh CLI to work with knative objects"
  homepage "https://triggermesh.com"
  url "https://github.com/triggermesh/tm/archive/v1.20.0.tar.gz"
  sha256 "f7fdf4b8e4d5f2e5742d77a67d521cdd33c88429a56ea939acce077094a6397e"
  license "Apache-2.0"
  head "https://github.com/triggermesh/tm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86bd627c52000a9a73715c8089c568dd09fe181d61da1e2f8e47c3efbd9aabaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71fcb7725c662710d2db2b52868e1fd606ecc1564020723df227c96780da0872"
    sha256 cellar: :any_skip_relocation, monterey:       "d84cbf414d8f066150b06e2e4a17d9e0309a734eba1c23913b45743bc7580b28"
    sha256 cellar: :any_skip_relocation, big_sur:        "edcb9f503b891fb0703b8daa41ea30483bdd9c971380e5a0c7f478de69023012"
    sha256 cellar: :any_skip_relocation, catalina:       "7d7279fcc0ecce2e09a4a6d2e2b10c1b9ed1150b1fc0044e715b77c129f8f672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a1d22e5926177b15fe275485ab71fbedb38e307b97971fd395725ff37ab460"
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
