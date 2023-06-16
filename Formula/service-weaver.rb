class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.15.0.tar.gz"
    sha256 "f35bbda3bfa184c395d8218ddcbf2975fd68a6fd654c448c2f131316892757c7"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.13.0.tar.gz"
      sha256 "bb34cdad729d842b398ab04363f8f5907c68a68e2cccba63538adf9ef29c139b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380801a0b4fedf00f4f5c4ca027f543afcfb06ae40dc6f00257bb470d79513b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b61d4185235be654d736b5be974054a09c39cc75897191628e278aafca4aeae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebbd97edbe1b8c47d169a468d02fea522a33b561aa2c2727e6791712f9a8784d"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc723851f0e73126303789ac3e6066a107af6d6716a9b8afbc8ff0eace4abd3"
    sha256 cellar: :any_skip_relocation, monterey:       "a8a662a6e7c2231f2f0dd3414e798be0c853ddc3bf3d1df5b98091c3c7baa9bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b769b3db2101d1f666a52d9ad2fdd1eeb0be84863e2ef50a406cb6ebd3c9986e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c2f5e65522a32982cfb64e9f6ddb3de1abdd9790e195cc229ef0cae11ff261"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end
