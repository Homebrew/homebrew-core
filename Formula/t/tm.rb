class Tm < Formula
  desc "TriggerMesh CLI to work with knative objects"
  homepage "https://triggermesh.com"
  url "https://github.com/triggermesh/tm/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "865d62d11ac28536ed630562088ca8537ceb5c54fcbc413788171f98ab301df2"
  license "Apache-2.0"
  head "https://github.com/triggermesh/tm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b87ee9cdc5bff6989252c305af1da3540d847784eea6f895acb5cd589abdafd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb35c98edad2b1a8ea811001ca4c9df94cd4313717622b0da3ee0b04e518e6fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a457f9d2f739486050e6f0e952f881c804cd15eba2007375523bf5cb85e92f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55ee1208229d3940370f20a88131eadeb396084a07720000c3484fa5b82d56a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a63d19c633b0be034cc7bb8454f140c18273399890c25048f20fe3227c2b7217"
    sha256 cellar: :any_skip_relocation, sonoma:         "f220342f0f170328bb1792e493e89b153738b8a32176f22c7f166afe83f220e9"
    sha256 cellar: :any_skip_relocation, ventura:        "6c14190586c9aab45552232a455c4c9f0483ce3b14e3928216eed82e9b0f411a"
    sha256 cellar: :any_skip_relocation, monterey:       "71035b89d26e7a8f1e03bde9cd7f9c1b3abb288703ee5719059be45e899d0401"
    sha256 cellar: :any_skip_relocation, big_sur:        "b38ad58b65ceb623a5c816f1c20c46dcfb9e941f3c80a2353a1845ab356b2e10"
    sha256 cellar: :any_skip_relocation, catalina:       "1d325bf50624c61747e81862667df2f74abfb03889c5dd1ad6f008136ba03c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58105d9cd50de7d0aa4e130051b6819670acbb2c53702ed9c783d90f92b610ff"
  end

  deprecate! date: "2024-03-15", because: :repo_archived
  disable! date: "2025-03-24", because: :repo_archived

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/triggermesh/tm/cmd.version=v#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"kubeconfig").write <<~YAML
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
    YAML

    ENV["KUBECONFIG"] = testpath/"kubeconfig"

    # version
    version_output = shell_output("#{bin}/tm version")
    assert_match "Triggermesh CLI, version v#{version}", version_output

    # node
    system bin/"tm", "generate", "node", "foo-node"
    assert_path_exists testpath/"foo-node/serverless.yaml"
    assert_path_exists testpath/"foo-node/handler.js"

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/node10/runtime.yaml"
    yaml = File.read("foo-node/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml

    # python
    system bin/"tm", "generate", "python", "foo-python"
    assert_path_exists testpath/"foo-python/serverless.yaml"
    assert_path_exists testpath/"foo-python/handler.py"

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/python37/runtime.yaml"
    yaml = File.read("foo-python/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml

    # go
    system bin/"tm", "generate", "go", "foo-go"
    assert_path_exists testpath/"foo-go/serverless.yaml"
    assert_path_exists testpath/"foo-go/main.go"

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/go/runtime.yaml"
    yaml = File.read("foo-go/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml

    # ruby
    system bin/"tm", "generate", "ruby", "foo-ruby"
    assert_path_exists testpath/"foo-ruby/serverless.yaml"
    assert_path_exists testpath/"foo-ruby/handler.rb"

    runtime = "https://raw.githubusercontent.com/triggermesh/knative-lambda-runtime/master/ruby25/runtime.yaml"
    yaml = File.read("foo-ruby/serverless.yaml")
    assert_match "runtime: #{runtime}", yaml
  end
end
