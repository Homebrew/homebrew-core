class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.12.0",
      revision: "a18afbfc561cd8ef94f42195df752561a9ee99ee"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfb074d7305d47f98fcad6ddb400fdc7c2dd6d67219055b4680b341618dfd48a" => :big_sur
    sha256 "ae879d553dfbb7192815501cc32d316fd5dd4b3abb2454d75a14524190b7008e" => :catalina
    sha256 "59fb9e2e8550d2a6ad499f53731a2296d8f4f0d10314ab3aca459269f56dc847" => :mojave
    sha256 "111253df69414d6238ef88c60c3c79a682a61e2bcd5ba6d265676bccda037ba5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "make", "static"
    bin.install "tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system "#{bin}/tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
