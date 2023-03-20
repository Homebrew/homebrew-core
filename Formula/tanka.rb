class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.24.0",
      revision: "4a5380587ea73950563fbbd679e527cb77ab2560"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bc3846481e5446d4742e8a903fd758c0d9836ce78a30ee3f9af7a3b28ec541b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc3846481e5446d4742e8a903fd758c0d9836ce78a30ee3f9af7a3b28ec541b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bc3846481e5446d4742e8a903fd758c0d9836ce78a30ee3f9af7a3b28ec541b"
    sha256 cellar: :any_skip_relocation, ventura:        "05398f6712f1d60d683797aa72cfe5f0b7bc16eb02a04e1a22cc0ce6efe01252"
    sha256 cellar: :any_skip_relocation, monterey:       "05398f6712f1d60d683797aa72cfe5f0b7bc16eb02a04e1a22cc0ce6efe01252"
    sha256 cellar: :any_skip_relocation, big_sur:        "05398f6712f1d60d683797aa72cfe5f0b7bc16eb02a04e1a22cc0ce6efe01252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2fa079b2592f8ebd870501dedf5a908f26e0d4f8ddb37f4ffa421eac4c13839"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CURRENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
