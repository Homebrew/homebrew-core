class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.27.1",
      revision: "d5d844986650ba12edf35d1a9537fa602130f7e7"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c7acf431d9b78d102a5d35de2c830c4028a553efc248eb757af2ac0ad64406a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c7acf431d9b78d102a5d35de2c830c4028a553efc248eb757af2ac0ad64406a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c7acf431d9b78d102a5d35de2c830c4028a553efc248eb757af2ac0ad64406a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e6017123bed600363b96a9b5f66e888325fb589300c88afb3204671a6ca5567"
    sha256 cellar: :any_skip_relocation, ventura:        "7e6017123bed600363b96a9b5f66e888325fb589300c88afb3204671a6ca5567"
    sha256 cellar: :any_skip_relocation, monterey:       "7e6017123bed600363b96a9b5f66e888325fb589300c88afb3204671a6ca5567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d53c40ba03e6245955de910a004ef936251339d11c33752ce36619632f4567"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
